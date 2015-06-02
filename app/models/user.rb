class User < ActiveRecord::Base

  include ActionView::Helpers

  TEMP_EMAIL_PREFIX = "change@me"
  TEMP_EMAIL_REGEX = /\Achange@me/

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :omniauthable, :registerable,
         :recoverable, :trackable, :validatable, :rememberable, :async

  mount_uploader :profile_image, ProfileImageUploader

  belongs_to :team
  has_many :subscriptions, dependent: :destroy

  validates :email, presence: true
  validates :email, uniqueness: true
  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update

  delegate :plan, to: :subscription, allow_nil: true
  delegate :scheduled_for_cancellation_on, to: :subscription, allow_nil: true

  before_save :ensure_authentication_token_is_present

  def self.find_for_oauth(auth, signed_in_resource=nil)
    identity = Identity.find_for_oauth(auth)
    user = signed_in_resource ? signed_in_resource : identity.user
    if user.nil?
      email = auth.info.email
      user = User.where(email: email).first if email

      if user.nil?

        name = auth.extra.raw_info.name
        if name
          first_name, *last_name = name.split
          last_name = last_name.join(" ")
        end

        user = User.new(
          first_name: first_name,
          last_name: last_name,
          email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0, 20]
        )
        user.save!

        plan = Plan.find_by(sku: "standard")
        checkout = plan.checkouts.build(
          user: user,
          email: user.email
        )
        checkout.fulfill
      end
    end

    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
  end

  def self.with_active_subscription
    includes(subscriptions: :plan, team: { subscription: :plan }).
      select(&:has_active_subscription?)
  end

  def self.subscriber_count
    Subscription.active.joins(team: :users).count +
      Subscription.active.includes(:team).where(teams: { id: nil }).count
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
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

  def create_subscription(plan:, stripe_id:, card_last_four_digits:, card_type:, card_expires_on:, trial_ends_at:)
    subscriptions.create(
      plan: plan,
      stripe_id: stripe_id,
      card_last_four_digits: card_last_four_digits,
      card_type: card_type,
      card_expires_on: card_expires_on,
      trial_ends_at: trial_ends_at
    )
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

  def in_trial_without_card?
    has_active_subscription? &&
      !subscription.has_credit_card? &&
      subscription.in_trial?
  end

  def trial_ends_at
    if has_active_subscription?
      subscription.trial_ends_at
    end
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

  def parse_first_name(full_name)
    if full_name
      first, *last = full_name.split
      first
    end
  end

  def parse_last_name(full_name)
    if full_name
      first, *last = full_name.split
      last.join(" ")
    end
  end

end
