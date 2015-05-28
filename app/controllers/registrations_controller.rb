class RegistrationsController < Devise::RegistrationsController

  before_action :load_resource, only: [:edit_password, :update_password]

  def create
    super
    if resource.save
      @checkout = build_checkout
      @checkout.fulfill
      flash[:notice] = "You are now registered with Jumpstart, and your 30 day free trial has begun."
    else
      flash[:error] = "Error created new user."
    end
  end

  def edit_password
    respond_with resource
  end

  def update_password
    if update_resource(resource, password_update_params)
      if is_flashing_format?
        set_flash_message :notice, :updated
        sign_in(resource_name, resource, bypass: true)
        respond_with(resource, location: after_update_path_for(resource))
      end
    else
      clean_up_passwords resource
      respond_with(resource, action: 'edit_password')
    end
  end

  private

  def build_checkout
    plan = Plan.find_by(sku: "standard")
    user = current_user
    plan.checkouts.build(
      user: user,
      email: user.email
    )
  end

  def sign_up_params
    resource_params.permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end

  def account_update_params
    resource_params.permit(
      :address1,
      :address2,
      :city,
      :country,
      :current_password,
      :email,
      :first_name,
      :last_name,
      :organization,
      :profile_image,
      :state,
      :zip_code
    )
  end

  def password_update_params
    resource_params.permit(:password, :password_confirmation, :current_password)
  end

  def resource_params
    params.require(:user)
  end

  def load_resource
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
  end

end
