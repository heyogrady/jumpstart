require "test_helper"

class Subscriber::InvoicesControllerTest < ActionController::TestCase

  fixtures :users

  def setup
    request.env["HTTP_REFERER"] = "http://test.com"
    @nancy = users(:nancy)
    sign_in(@nancy)
  end

  def test_index
    get :index
    assert_response :success
  end

end
