class SubscriptionMailer < BaseMailer

  def welcome_to_jumpstart(user)
    @user = user

    mail(
      to: @user.email,
      subject: t("mailers.subscription.welcome_to_jumpstart")
    )
  end

end
