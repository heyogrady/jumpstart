class Mailer < BaseMailer

  def contact_us_notification(contact)
    @email = contact.email
    @title = contact.title
    @body  = contact.body
    subject = "Contact us message from #{@email}"

    mail(
      to: Rails.application.secrets.support_email,
      from: @email,
      subject: subject
    ) do |format|
      format.html
    end
  end

end
