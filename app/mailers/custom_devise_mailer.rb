# frozen_string_literal: true

# Custom Devise Mailer to override default email subjects
class CustomDeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  include ActionView::Helpers::TranslationHelper # Optional. eg. `t()`

  layout 'mailer' # Use the same layout as ApplicationMailer

  helper :application # Access to all helpers defined within `application_helper`.

  attr_reader :current_theme

  helper_method :current_theme

  protected

  # Override headers_for to customize email subjects and templates based on user subscription type
  # This method is called internally by Devise to set up email headers, but is our only chance to
  # customize the contents and layout based on the subscription type.
  def headers_for(action, opts) # rubocop:disable Metrics/AbcSize
    @current_theme = opts[:subscription_type]&.to_sym || :decidodeck
    @host = opts[:host] || Rails.application.config.action_mailer.default_url_options[:host]

    attachments.inline['logo.png'] = File.read(logo_attachment_file_path_for_resource)
    @application_name = application_name_for_current_theme

    super(action, opts).tap do |headers|
      # Only customize for certain actions. Other actions (e.g. reset_password_instructions)
      # will use the default Devise behavior. Maybe we should either customize those too,
      # or defer to a convention (if a theme-specific template exists, use that - otherwise
      # use the default).
      if %i[confirmation_instructions invitation_instructions].include?(action)
        headers[:subject] = subject_for_current_theme(headers[:subject])
        headers[:template_name] = template_name_for_current_theme(action)
      end
    end
  end

  private

  def application_name_for_current_theme
    case current_theme
    when :free_sdg
      'Free SDG'
    else
      'Obsekio'
    end
  end

  def logo_attachment_file_path_for_resource
    case current_theme
    when :free_sdg
      Rails.root.join('app/assets/images/themes/free_sdg/brand.png')
    else
      Rails.root.join('app/assets/images/logo-small.png')
    end
  end

  def subject_for_current_theme(default_subject)
    case current_theme
    when :free_sdg
      "Free SDG - #{default_subject}"
    else
      default_subject
    end
  end

  def template_name_for_current_theme(action)
    case current_theme
    when :free_sdg
      "#{action}_free_sdg"
    else
      action.to_s
    end
  end
end
