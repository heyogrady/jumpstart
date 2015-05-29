class CreditCardInfoUpdater

  attr_reader :user, :stripe_customer

  def initialize(user:, stripe_customer:)
    @user = user
    @stripe_customer = stripe_customer
  end

  def process
    card = stripe_customer.cards.data.first
    subscription = user.subscription

    subscription.update!(
      card_last_four_digits: card.last4,
      card_type: card.brand,
      card_expires_on: convert_expiry_date(card.exp_month, card.exp_year)
    )
  end

  private

  def convert_expiry_date(month, year)
    Date.new(year.to_i, month.to_i, 1)
  end

end
