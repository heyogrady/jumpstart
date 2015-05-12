module AnalyticsHelper

  def analytics?
    ENV["ANALYTICS"].present?
  end

  def identify_hash(user=current_user)
    {
      created: user.created_at,
      email: user.email,
      has_active_subscription: user.has_active_subscription?,
      name: user.name,
      plan: user.plan_name,
      scheduled_for_cancellation_on: user.scheduled_for_cancellation_on,
      stripe_customer_url: StripeCustomer.new(user).url,
      subscribed_at: user.subscribed_at,
      user_id: user.id
    }
  end

  def intercom_hash(user=current_user)
    {
      "Intercom" => {
        userHash: OpenSSL::HMAC.hexdigest(
          "sha256",
          Settings.intercom.api_secret,
          user.id.to_s
        )
      }
    }
  end

  def purchased_hash
    campaign_hash.merge(revenue: flash[:purchase_amount])
  end

  def campaign_hash
    {
      context: {
        campaign: session[:campaign_params]
      }
    }
  end

end
