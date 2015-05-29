ActionMailer::Base.default_url_options[:host] = Rails.application.secrets.host

ActionMailer::Base.delivery_method = Rails.application.secrets.mailer_delivery_method

if Rails.application.secrets.mailer_delivery_method == :smtp
  ActionMailer::Base.smtp_settings = Rails.application.secrets.mailer_smtp_settings
end
