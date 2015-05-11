Rails.configuration.stripe = {
  publishable_key: Settings.stripe.publishable_key,
  secret_key:      Settings.stripe.secret_key,
}

Stripe.api_key = \
  Rails.configuration.stripe[:secret_key]
STRIPE_PUBLIC_KEY = Settings.stripe.publishable_key
Stripe.api_version = "2014-09-08"
