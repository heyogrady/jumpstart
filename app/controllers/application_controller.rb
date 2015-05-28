class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_device_type
  before_action :set_layout_carrier

  def ensure_signup_complete
    return if action_name == "finish_signup"
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end

  protected

  def must_be_admin
    unless current_user_is_admin?
      deny_access("you do not have permission to view that page")
    end
  end

  def must_be_subscription_owner
    unless current_user_is_subscription_owner?
      deny_access("You must be the owner of this subscription")
    end
  end

  def current_user_is_subscription_owner?
    current_user_has_active_subscription? &&
      current_user.subscription.owner?(current_user)
  end
  helper_method :current_user_is_subscription_owner?

  def current_user_has_active_subscription?
    current_user && current_user.has_active_subscription?
  end
  helper_method :current_user_has_active_subscription?

  def current_user_is_admin?
    current_user && current_user.admin?
  end

  def current_team
    current_user.team
  end
  helper_method :current_team

  def current_user_has_access_to?(feature)
    current_user && current_user.has_access_to?(feature)
  end

  private

  def ensure_current_user_is_superadmin!
    authenticate_user!

    unless current_user.super_admin?
      redirect_to root_path, status: :forbidden, alert: "Unauthorized Access!"
    end
  end

  def set_device_type
    request.variant = :phone if browser.mobile?
  end

  def set_layout_carrier
    @layout_carrier = LayoutCarrier.new
  end

  def deny_access(message)
    flash[:error] = message
    redirect_to :back || root_url
  end

end
