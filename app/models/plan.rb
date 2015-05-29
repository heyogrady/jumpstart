class Plan < ActiveRecord::Base

  DISCOUNTED_ANNUAL_PLAN_SKU = "175-annually"
  LITE_PLAN_SKU = "lite"
  STANDARD_PLAN_SKU = "standard"
  PROFESSIONAL_PLAN_SKU = "professional"

  has_many :checkouts
  has_many :subscriptions, as: :plan
  belongs_to :annual_plan, class_name: "Plan"

  validates :description, presence: true
  validates :price_in_dollars, presence: true
  validates :name, presence: true
  validates :short_description, presence: true
  validates :sku, presence: true

  include PlanForPublicListing

  def self.individual
    where includes_team: false
  end

  def self.team
    where includes_team: true
  end

  def self.active
    where active: true
  end

  def self.default
    individual.active.featured.ordered.first
  end

  def self.default_team
    team.active.featured.ordered.first
  end

  def self.discounted_annual
    where(sku: DISCOUNTED_ANNUAL_PLAN_SKU).first
  end

  def self.basic
    where(sku: LITE_PLAN_SKU).first
  end

  def self.popular
    where(sku: STANDARD_PLAN_SKU).first
  end

  def popular?
    self == self.class.popular
  end

  def subscription_interval
    stripe_plan.interval
  end

  def fulfill(checkout, user)
    user.create_subscription(
      plan: self,
      stripe_id: checkout.stripe_subscription_id,
      card_last_four_digits: checkout.card_last_four_digits,
      card_type: checkout.card_type,
      card_expires_on: checkout.card_expires_on,
      trial_ends_at: checkout.trial_ends_at
    )
    SubscriptionFulfillment.new(user, self).fulfill
    if includes_team?
      TeamFulfillment.new(checkout, user).fulfill
    end
  end

  def included_in_plan?(plan)
    false
  end

  def has_annual_plan?
    annual_plan.present?
  end

  def has_feature?(feature)
    public_send("includes_#{feature}?")
  end

  def annualized_payment
    12 * price_in_dollars
  end

  def discounted_annual_payment
    annual_plan.price_in_dollars
  end

  def annualized_savings
    annualized_payment - discounted_annual_payment
  end

  def annual_plan_sku
    annual_plan.sku
  end

  private

  def stripe_plan
    @stripe_plan ||= Stripe::Plan.retrieve(sku)
  end

end
