namespace :notifications do
  desc "Send welcome emails to those who subscribed to Jumpstart in the last 24 hours"
  task jumpstart_welcome: :environment do
    Subscription.deliver_welcome_emails
  end
end
