# frozen_string_literal: true

# Mailer for contact requests.
class ContactMailer < ApplicationMailer
  def contact(name, email, message)
    @name = name
    @email = email
    @message = message

    attachments.inline['logo.png'] = File.read(Rails.root.join('app/assets/images/logo-small.png'))
    mail(subject: 'Contact request', to: contact_mail_recipients)
  end

  private

  def contact_mail_recipients
    ENV['CONTACT_MAIL_RECIPIENTS'].split(',')
  end

  # def mail_with_logo(headers = {}, &block)
  #   attachments.inline['logo.png'] = File.read(Rails.root.join('app/assets/images/logo-small.png'))
  #   mail(headers, &block)
  # end
end
