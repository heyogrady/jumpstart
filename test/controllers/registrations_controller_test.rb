require "test_helper"

class RegistrationsControllerTest < ActionController::TestCase

  fixtures :plans

  setup do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  def test_successful_user_registration
    stub_stripe_create_customer_request

    assert_difference("User.count") do
      post :create, {
        user: {
          email: "nancy@test.example.com",
          first_name: "Nancy",
          last_name: "Smith",
          password: "welcome",
          password_confirmation: "welcome"
        }
      }
    end
    assert_redirected_to root_path
  end

  def test_required_parameters
    assert_no_difference("User.count") do
      post :create, {
        user: {
          first_name: "Steve",
          last_name: "Smith",
          password: "welcome",
          password_confirmation: "welcome"
        }
      }
    end

    assert_response :success
  end

  def test_updates_password_given_valid_data
    nancy = users :nancy
    sign_in nancy

    get :edit_password
    assert_response :success

    valid_user_data = { password: "new password", password_confirmation: "new password", current_password: "welcome" }
    put :update_password, user: valid_user_data
    assert_redirected_to root_path
  end

  def test_does_not_update_password_given_invalid_data
    nancy = users :nancy
    sign_in nancy

    get :edit_password
    assert_response :success

    invalid_user_data = { password: "new password", password_confirmation: "new not matching password", current_password: "welcome" }

    put :update_password, user: invalid_user_data
    assert_response :success
    assert assigns(:user)
    @user = assigns(:user)
    assert @user.errors.count > 0
  end

  def test_updates_user_profile_given_valid_data
    nancy = users :nancy
    sign_in nancy

    get :edit
    assert_response :success

    valid_user_data = { first_name: "John2", current_password: "welcome" }
    put :update, user: valid_user_data
    assert_redirected_to root_path
    nancy.reload
    assert_equal nancy.first_name, valid_user_data[:first_name]
  end

  def test_new_subscription_when_user_created
    VCR.use_cassette("registrations controller user subscribes") do
      assert_difference("Subscription.count") do
        post :create, {
          user: {
            email: "nancy@test.example.com",
            first_name: "Nancy",
            last_name: "Smith",
            password: "welcome",
            password_confirmation: "welcome"
          }
        }
      end
    end

    user = User.find_by(email: "nancy@test.example.com")
    assert_not_empty user.stripe_customer_id, "No customer ID found"
  end

  private

  def stub_stripe_create_customer_request
    stub_request(:post, "https://api.stripe.com/v1/customers").
      with(:body => {"description"=>"nancy@test.example.com", "email"=>"nancy@test.example.com"},
           :headers => { 'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Bearer sk_test_VnDYa71zaDELvFZeHx8rKDJz', 'Content-Length'=>'67', 'Content-Type'=>'application/x-www-form-urlencoded', 'Stripe-Version'=>'2014-09-08', 'User-Agent'=>'Stripe/v1 RubyBindings/1.15.0', 'X-Stripe-Client-User-Agent'=>'{"bindings_version":"1.15.0","lang":"ruby","lang_version":"2.2.2 p95 (2015-04-13)","platform":"x86_64-darwin14","publisher":"stripe","uname":"Darwin Patricks-MacBook-Pro.local 14.3.0 Darwin Kernel Version 14.3.0: Mon Mar 23 11:59:05 PDT 2015; root:xnu-2782.20.48~5/RELEASE_X86_64 x86_64"}' }).
      to_return(:status => 200, :body => "", :headers => {})
  end

end
