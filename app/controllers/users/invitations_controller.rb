# frozen_string_literal: true

module Users
  # Controller for managing User Invitations
  class InvitationsController < Devise::InvitationsController
    before_action :configure_invite_params, only: [:create]

    layout 'application', only: [:new] # NOTE: Defaults to 'devise' layout for other actions

    def create # rubocop:disable Metrics/AbcSize,Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
      workspace_role = params[:workspace_role].downcase
      account_role = params[:account_role].downcase

      user = User.find_by(email: params[:user][:email])

      if user
        user.subscription_type = params[:user][:subscription_type]
        if current_workspace.members.include?(user)
          redirect_to users_path, alert: "A user with the email '#{user.email}' is already a member of this workspace."
        elsif current_workspace.max_users_reached? && !current_user.admin?
          redirect_to users_path, alert: 'You have reached the maximum number of users for this workspace.'
        else
          AccountMember.create!(user: user, account: current_account, role: account_role)
          WorkspaceMember.create!(user: user, workspace: current_workspace, role: workspace_role)

          redirect_to users_path, notice: 'User was successfully invited.'
          # TODO: Send email to existing user notifying them they have been added to the workspace
        end
      elsif current_workspace.max_users_reached? && !current_user.admin?
        redirect_to users_path, alert: 'You have reached the maximum number of users for this workspace.'
      else
        super do |resource|
          if resource.errors.empty?
            AccountMember.create!(user: resource, account: current_account, role: account_role)
            WorkspaceMember.create!(user: resource, workspace: current_workspace, role: workspace_role)
          end
        end
      end
    end

    def new
      self.resource = resource_class.new
      authorize resource, :invite?
      render :new
    end

    private

    def configure_invite_params
      devise_parameter_sanitizer.permit(:invite, keys: %i[subscription_type name])
    end

    # SMELL: This method is duplicated in Users::RegistrationsController
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
