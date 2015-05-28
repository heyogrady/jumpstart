class SubscriptionsController < ApplicationController

  before_filter :must_be_subscription_owner, only: [:edit, :update]

  def new
    @landing_page = LandingPage.new

    render layout: "landing_pages"
  end

  def edit
    @catalog = Catalog.new

    render layout: "header-only"
  end

  def update
    if current_user.subscription.change_plan(sku: params[:plan_id])
      redirect_to(
        profile_path,
        notice: I18n.t("subscriptions.flashes.change.success")
      )
    else
      redirect_to(
        profile_path,
        notice: "Please add a card."
      )
    end
  end

end
