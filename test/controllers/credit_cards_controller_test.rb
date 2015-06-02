require "test_helper"

class CreditCardsControllerTest < ActionController::TestCase

  def test_new
    nancy = users :nancy
    sign_in nancy

    get :new
  end

end
