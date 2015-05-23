require "test_helper"

class Subscriber::CancellationsControllerTest < ActionController::TestCase

  def setup
    request.env["HTTP_REFERER"] = "http://test.com"
  end

  def test_create
    post :create, cancellation: { reason: "reason" }
    assert_response 302
  end

  def test_new
    get :new
    assert_response 302
  end

end
