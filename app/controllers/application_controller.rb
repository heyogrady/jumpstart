class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_device_type
  before_action :set_layout_carrier

  protected

  def must_be_admin
    unless current_user_is_admin?
      flash[:error] = "you do not have permission to view that page"
      redirect_to root_url
    end
  end

  def current_user_is_admin?
    current_user && current_user.admin?
  end

  def current_team
    current_user.team
  end

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

end
