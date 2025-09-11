# frozen_string_literal: true

# Base class for all mailers in the application.
class ApplicationMailer < ActionMailer::Base
  layout 'mailer' # Use the same layout as ApplicationMailer
  helper :application # Access to all helpers defined within `application_helper`.

  default from: 'contact@decidodeck.com' # TODO: Move to ENV

  def current_theme
    :decidodeck
  end

  def current_theme_display_name
    'Decidodeck'
  end

  helper_method :current_theme
  helper_method :current_theme_display_name
end
