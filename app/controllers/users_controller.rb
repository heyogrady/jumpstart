class UsersController < ApplicationController

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      sign_in(@user == current_user ? @user : current_user, bypass: true)
      redirect_to(
        profile_url,
        notice: "Successfully updated your profile."
      )
    else
      flash[:error] = "Could not save profile. Please try again."
      render "users/registrations/edit"
    end
  end

  def finish_signup
    @user = User.find(params[:id])
    if request.patch? && params[:user]
      if @user.update(user_params)
        sign_in(@user, bypass: true)
        @checkout = build_checkout
        if @checkout.fulfill
          redirect_to(root_url, notice: "Successfully signed up for 30 day trial.")
        else
          flash[:error] = "Error initializing trial."
        end
      else
        flash[:error] = "Could not save email address. Please try again."
      end
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

  def user_params
    params.require(:user).permit(
      :address1,
      :address2,
      :city,
      :country,
      :email,
      :first_name,
      :last_name,
      :organization,
      :profile_image,
      :state,
      :zip_code
    )
  end

end
