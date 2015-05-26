class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def self.provides_callback_for(provider)
    class_eval %Q{
      def #{provider}
        @user = User.find_for_oauth(env["omniauth.auth"], current_user)

        if @user.persisted?
          @checkout = build_checkout
          if @checkout.fulfill
            sign_in_and_redirect @user, event: :authentication
            set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
          else
            flash[:error] = "Error starting trial subscription."
            redirect_to new_user_registration_url
          end
        else
          session["devise.#{provider}_data"] = env["omniauth.auth"]
          redirect_to new_user_registration_url
        end
      end
    }
  end

  [:facebook, :google, :linked_in, :twitter].each do |provider|
    provides_callback_for provider
  end

  def after_sign_in_path_for(resource)
    if resource.email_verified?
      super resource
    else
      finish_signup_path(resource)
    end
  end

  private

  def build_checkout
    plan = Plan.find_by(sku: "standard")
    plan.checkouts.build(
      user: @user,
      email: @user.email
    )
  end

end
