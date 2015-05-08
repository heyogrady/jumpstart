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

  def deliver_welcome_email
    SubscriptionMailer.welcome_to_jumpstart(user).deliver_now
  end

  private

  def self.cancelled_within_period(start_time, end_time)
    where(deactivated_on: start_time...end_time)
  end

  def self.recent
    where("created_at > ?", 24.hours.ago)
  end

end
