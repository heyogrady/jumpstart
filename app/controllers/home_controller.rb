class HomeController < ApplicationController

  def index
    render
  end

  def show
    if user_signed_in?
      redirect_to dashboard_url
    else
      redirect_to join_url
    end
  end

end
