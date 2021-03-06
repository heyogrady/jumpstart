class StripeSubscription

  attr_reader :id, :trial_ends_at

  def initialize(checkout)
    @checkout = checkout
  end

  def create
    rescue_stripe_exception do
      ensure_customer_exists
      update_subscription
    end
  end

  private

  def rescue_stripe_exception
    yield
    true
  rescue Stripe::StripeError => exception
    @checkout.errors[:base] <<
      "There was a problem processing your credit card, " +
        exception.message.downcase
    false
  end

  def ensure_customer_exists
    if customer_exists?
      update_card
    else
      create_customer
    end
  end

  def update_card
    stripe_customer.card = @checkout.stripe_token
    stripe_customer.save
  end

  def customer_exists?
    @checkout.stripe_customer_id.present?
  end

  def create_customer
    new_stripe_customer = Stripe::Customer.create(
      card: @checkout.stripe_token,
      description: @checkout.email,
      email: @checkout.email
    )
    if @checkout.stripe_token
      card = new_stripe_customer.cards.data.first
      @checkout.card_last_four_digits = card.last4
      @checkout.card_type = card.brand
      @checkout.card_expires_on = convert_expiry_date(card.exp_month, card.exp_year)
    end
    @checkout.stripe_customer_id = new_stripe_customer.id
  end

  def update_subscription
    if stripe_customer.subscriptions.total_count == 0
      subscription =
        stripe_customer.subscriptions.create(subscription_attributes)
    else
      subscription = stripe_customer.subscriptions.first
      subscription_attributes.each { |key, value| subscription[key] = value }
      subscription.save
    end

    if trial_end_timestamp = subscription.trial_end
      @trial_ends_at = Time.zone.at(trial_end_timestamp)
    end

    @id = subscription.id
  end

  def subscription_attributes
    base_subscription_attributes.merge(coupon_attributes)
  end

  def base_subscription_attributes
    {
      plan: @checkout.plan_sku,
      quantity: @checkout.quantity
    }
  end

  def coupon_attributes
    if @checkout.stripe_coupon_id.present?
      { coupon: @checkout.stripe_coupon_id }
    else
      {}
    end
  end

  def stripe_customer
    @stripe_customer ||= Stripe::Customer.retrieve(@checkout.stripe_customer_id)
  end

  def convert_expiry_date(month, year)
    Date.new(year.to_i, month.to_i, 1)
  end

end
