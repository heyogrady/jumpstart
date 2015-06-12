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

  private

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
