class User < ActiveRecord::Base

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :trackable, :validatable, :rememberable, :async

  mount_uploader :profile_image, ProfileImageUploader

  belongs_to :team
  has_many :subscriptions, dependent: :destroy

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  delegate :plan, to: :subscription, allow_nil: true
  delegate :scheduled_for_cancellation_on, to: :subscription, allow_nil: true

  before_save :ensure_authentication_token_is_present

  def self.with_active_subscription
    includes(subscriptions: :plan, team: { subscription: :plan }).
      select(&:has_active_subscription?)
  end

  def self.subscriber_count
    Subscription.active.joins(team: :users).count +
      Subscription.active.includes(:team).where(teams: { id: nil }).count
  end

  def name
    [first_name, last_name].join(" ").strip
  end

  def super_admin?
    role == "super_admin"
  end

  def as_json(options={})
    new_options = options.merge(only: [:email, :first_name, :last_name, :current_sign_in_at])

    super new_options
  end

  def inactive_subscription
    if has_active_subscription?
      nil
    else
      most_recently_deactivated_subscription
    end
  end

  def create_subscription(plan:, stripe_id:)
    subscriptions.create(plan: plan, stripe_id: stripe_id)
  end

  def has_active_subscription?
    subscription.present?
  end

  def has_access_to?(feature)
    subscription.present? && subscription.has_access_to?(feature)
  end

  def subscribed_at
    subscription.try(:created_at)
  end

  def credit_card
    customer = stripe_customer

    if customer
      customer.cards.detect { |card| card.id == customer.default_card }
    end
  end

  def plan_name
    plan.try(:name)
  end

  def team_owner?
    team && team.owner?(self)
  end

  def subscription
    [personal_subscription, team_subscription].compact.detect(&:active?)
  end

  def eligible_for_annual_upgrade?
    plan.present? && plan.has_annual_plan?
  end

  def annualized_payment
    plan.annualized_payment
  end

  def discounted_annual_payment
    plan.discounted_annual_payment
  end

  def annual_plan_sku
    plan.annual_plan_sku
  end

  def deactivate_personal_subscription
    if personal_subscription
      Cancellation.new(subscription: personal_subscription).cancel_now
    end
  end

  def has_credit_card?
    stripe_customer_id.present?
  end

  private

  def ensure_authentication_token_is_present
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  def personal_subscription
    subscriptions.detect(&:active?)
  end

  def team_subscription
    if team.present?
      team.subscription
    end
  end

  def stripe_customer
    if stripe_customer_id.present?
      Stripe::Customer.retrieve(stripe_customer_id)
    end
  end

  def most_recently_deactivated_subscription
    [*subscriptions, team_subscription].
      compact.
      reject(&:active?).
      max_by(&:deactivated_on)
  end

end
