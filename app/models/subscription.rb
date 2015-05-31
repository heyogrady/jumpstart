class Subscription < ActiveRecord::Base

  belongs_to :plan, polymorphic: true
  belongs_to :user
  has_one :team, dependent: :destroy

  delegate :name, to: :plan, prefex: true
  delegate :stripe_customer_id, to: :user

  validates :plan_id, presence: true
  validates :plan_type, presence: true
  validates :user_id, presence: true

  def self.deliver_welcome_emails
    recent.each do |subscription|
      subscription.deliver_welcome_email
    end
  end

  def self.canceled_in_last_30_days
    canceled_within_period(30.days.ago, Time.zone.now)
  end

  def self.active_as_of(time)
    where("deactivated_on is null OR deactivated_on > ?", time)
  end

  def self.created_before(time)
    where("created_at <= ?", time)
  end

  def self.next_payment_in_2_days
    where(next_payment_on: 2.days.from_now)
  end

  def active?
    deactivated_on.nil?
  end

  def scheduled_for_cancellation?
    scheduled_for_cancellation_on.present?
  end

  def deactivate
    SubscriptionFulfillment.new(user, plan).remove
    update_column(:deactivated_on, Time.zone.today)
  end

  def change_plan(sku:)
    if stripe_customer.sources.all(object: "card").data.empty?
      return false
    end

    write_plan(sku: sku)
    change_stripe_plan(sku: sku)
  end

  def write_plan(sku:)
    update_features do
      self.plan = Plan.find_by!(sku: sku)
      save!
      track_updated
    end
  end

  def change_stripe_plan(sku:)
    subscription = stripe_customer.subscriptions.first
    subscription.plan = sku
    subscription.save
  end

  def change_quantity(new_quantity)
    subscription = stripe_customer.subscriptions.first
    subscription.plan = plan.sku
    subscription.quantity = new_quantity
    subscription.save
  end

  def deliver_welcome_email
    SubscriptionMailer.welcome_to_jumpstart(user).deliver_now
  end

  def has_access_to?(feature)
    active? && plan.has_feature?(feature)
  end

  def team?
    team.present?
  end

  def last_change
    Stripe::Charge.all(count: 1, customer: stripe_customer_id).first
  end

  def owner?(other_user)
    user == other_user
  end

  def next_payment_amount_in_dollars
    next_payment_amount / 100
  end

  def in_trial?
    trial_ends_at.present? && trial_ends_at > Time.current
  end

  def has_credit_card?
    !card_last_four_digits.blank?
  end

  private

  def self.cancelled_within_period(start_time, end_time)
    where(deactivated_on: start_time...end_time)
  end

  def self.active
    where(deactivated_on: nil)
  end

  def self.recent
    where("created_at > ?", 24.hours.ago)
  end

  def update_features
    old_plan = plan
    yield
    new_plan = plan
    update_feature_fulfillments(old_plan, new_plan)
  end

  def update_feature_fulfillments(old_plan, new_plan)
    feature_fulfillment = FeatureFulfillment.new(
      new_plan: new_plan,
      old_plan: old_plan,
      user: user
    )
    feature_fulfillment.fulfill_gained_features
    feature_fulfillment.unfulfill_lost_features
  end

  def track_updated
    users_for_analytics_tracking.each do |user|
      Analytics.new(user).track_updated
    end
  end

  def users_for_analytics_tracking
    if team
      team.users
    else
      [user]
    end
  end

  def stripe_customer
    Stripe::Customer.retrieve(stripe_customer_id)
  end

end
