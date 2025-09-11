# frozen_string_literal: true

# Custom Devise Mailer to override default email subjects
class CustomDeviseMailer < Devise::Mailer
  include Devise::Controllers::UrlHelpers # Optional. eg. `confirmation_url`
  include ActionView::Helpers::TranslationHelper # Optional. eg. `t()`

  layout 'mailer' # Use the same layout as ApplicationMailer

  helper :application # Access to all helpers defined within `application_helper`.

  def current_theme
    resource&.subscription_type&.to_sym || :decidodeck
  end

  helper_method :current_theme

  protected

  # Override headers_for to customize email subjects and templates based on user subscription type
  # This method is called internally by Devise to set up email headers, but is our only chance to
  # customize the contents and layout based on the subscription type.
  def headers_for(action, opts)
    attachments.inline['logo.png'] = File.read(logo_attachment_file_path_for_resource)
    @application_name = application_name_for_resource

    super(action, opts).tap do |headers|
      if action == :confirmation_instructions
        headers[:subject] = subject_for_current_theme
        headers[:template_name] = template_name_for_current_theme
      end
    end
  end

  private

  def application_name_for_resource
    case resource.subscription_type&.to_sym
    when :free_sdg
      'Free SDG'
    else
      'Decidodeck'
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

  def subject_for_current_theme
    case current_theme
    when :free_sdg
      'Free SDG - Confirm your email address'
    else
      'Confirm your email address'
    end
  end

  def template_name_for_current_theme
    case current_theme
    when :free_sdg
      'confirmation_instructions_free_sdg'
    else
      'confirmation_instructions'
    end
  end
end
