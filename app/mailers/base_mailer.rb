class BaseMailer < ActionMailer::Base

  layout "mailer"

  default from: Rails.application.secrets.mailer_default_from_email

  default_url_options[:host] = Rails.application.secrets.host

end
