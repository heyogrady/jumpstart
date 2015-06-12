require "test_helper"

class CreditCardsControllerTest < ActionController::TestCase

  def test_new
    user = create(:user)
    sign_in user

    get :new
  end

  def test_update
    user = create(:user)
    sign_in user

    # post :update, stripe_token: "tok_166KZ9HmzjC11TEYhLTo4wqh"
  end

end
