class Subscription < ActiveRecord::Base

  belongs_to :plan, polymorphic: true
  belongs_to :user

  delegate :name, to: :plan, prefex: true
  delegate :stripe_customer_id, to: :user

  validates :plan_id, presence: true
  validates :plan_type, presence: true
  validates :user_id, presence: true

end
