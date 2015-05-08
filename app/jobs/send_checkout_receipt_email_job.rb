class SendCheckoutReceiptEmailJob < Struck.new(:checkout_id)

  def self.enqueue(checkout_id)
    Delayed::Job.enqueue(new(checkout_id))
  end

  def perform
    checkout = Checkout.find(checkout_id)
    CheckoutMailer.receipt(checkout).deliver_now
  end

end
