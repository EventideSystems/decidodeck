# frozen_string_literal: true

# Base class for all mailers in the application.
class ApplicationMailer < ActionMailer::Base
  default from: 'contact@decidodeck.com' # TODO: Move to ENV
  layout 'mailer'
end
