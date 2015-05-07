class Subscription < ActiveRecord::Base

  belongs_to :user

  delegate :stripe_customer_id, to: :user

  validates :plan_id, presence: true
  validates :plan_type, presence: true
  validates :user_id, presence: true

end
