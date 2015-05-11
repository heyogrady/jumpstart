module CheckoutsHelper

  def display_card_type(type)
    if type == "American Express"
      "AMEX"
    else
      type
    end
  end

  def submit_amount(checkout)
    formatted_subscription_price(checkout) +
      " per " +
      subscription_interval(checkout)
  end

  def formatted_subscription_price(checkout)
    if checkout.stripe_coupon_id.blank?
      number_to_currency(checkout.price, precision: 0)
    else
      formatted_subscription_price_with_coupon(checkout)
    end
  end

  def subscription_interval(checkout)
    checkout.plan.subscription_interval
  end

  def formatted_subscription_price_with_coupone(checkout)
    t("subscriptions.discount.#{checkout.coupon.duration}",
      final_price: number_to_currency(checkout.coupon.apply(checkout.price)),
      full_price: number_to_currency(checkout.price, precision: 0),
      duration_in_months: checkout.coupon.duration_in_months)
  end

  def choose_plan_link(plan)
    if current_user_has_active_subscription?
      change_plan_link(plan)
    else
      new_plan_link(plan)
    end
  end

  private

  def change_plan_link(plan)
    if current_user.plan == plan
      t("subscriptions.current_plan_html")
    else
      update_plan_link(plan)
    end
  end

  def update_plan_link(plan)
    link_to(
      t("subscriptions.choose_plan"),
      subscription_path(plan_id: plan),
      method: :put,
      class: "sign-up"
    )
  end

end
