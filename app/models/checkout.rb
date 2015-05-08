class Checkout < ActiveRecord::Base

  COMMON_ATTRIBUTES = %i(
    address1
    address2
    city
    country
    email
    name
    organization
    password
    state
    zip_code
  )

  belongs_to :plan
  belongs_to :user

  validates :user, presence: true

  delegate :email, to: :user, prefix: true

  attr_accessor \
    :stripe_customer_id,
    :stripe_subscription_id,
    :stripe_token,
    *COMMON_ATTRIBUTES

end
