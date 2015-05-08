class SubscriptionsController < ApplicationController

  def update
    current_user.subscription.change_plan(sku: params[:plan_id])
    redirect_to root
  end

end
