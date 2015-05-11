class BaseMailer < ActionMailer::Base

  layout "mailer"

  default from: Settings.mailer.default_from_email

  default_url_options[:host] = Settings.host

end
