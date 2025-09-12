# frozen_string_literal: true

module Users
  # Controller for managing User Registrations
  class RegistrationsController < Devise::RegistrationsController
    before_action :configure_sign_up_params, only: [:create]

    # POST /resource
    def create
      super do |resource|
        if resource.persisted?
          user_id = resource.id
          subscription_type = params[:user][:subscription_type] || 'free_sdg'
          SetupAccountJob.perform_later(user_id:, subscription_type:)
        end
      end
    end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:subscription_type])
    end

    # NOTE: See https://github.com/EventideSystems/decidodeck/issues/1276
    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end

    def subscription_type_for_current_theme
      case current_theme
      when :free_sdg
        'free_sdg'
      else
        'invoiced'
      end
    end

    helper_method :subscription_type_for_current_theme
  end
end
