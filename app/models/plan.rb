class Plan < ActiveRecord::Base

  DISCOUNTED_ANNUAL_PLAN_SKU = "175-annually"
  PRIME_249_SKU = "prime-249"
  PROFESSIONAL_SKU = "professional"
  THE_WEEKLY_ITERATION_SKU = "the-weekly-iteration"

  has_many :subscriptions, as: :plan
  belongs_to :annual_plan, class_name: "Plan"

  validates :description, presence: true
  validates :price_in_dollars, presence: true
  validates :name, presence: true
  validates :short_description, presence: true
  validates :sku, presence: true

end
