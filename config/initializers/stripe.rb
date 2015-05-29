Rails.configuration.stripe = {
  publishable_key: Rails.application.secrets.stripe["publishable_key"],
  secret_key:      Rails.application.secrets.stripe["secret_key"],
}

Stripe.api_key = \
  Rails.configuration.stripe[:secret_key]
STRIPE_PUBLIC_KEY = Rails.application.secrets.stripe["publishable_key"]
Stripe.api_version = "2014-09-08"
