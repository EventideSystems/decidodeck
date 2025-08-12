# frozen_string_literal: true

# Controller for managing User Invitations
class InvitationsController < Devise::InvitationsController
  layout 'application', only: [:new] # NOTE: Defaults to 'devise' layout for other actions

  def create # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
    workspace_role = params[:workspace_role].downcase
    account_role = params[:account_role].downcase

    user = User.find_by(email: params[:user][:email])

    if user
      if current_workspace.members.include?(user)
        redirect_to users_path, alert: "A user with the email '#{user.email}' is already a member of this workspace."
      elsif current_workspace.max_users_reached?
        redirect_to users_path, alert: 'You have reached the maximum number of users for this workspace.'
      else
        AccountMember.create!(user: user, account: current_account, role: account_role)
        WorkspaceMember.create!(user: user, workspace: current_workspace, workspace_role: workspace_role)

        redirect_to users_path, notice: 'User was successfully invited.'
      end
    elsif current_workspace.max_users_reached?
      redirect_to users_path, alert: 'You have reached the maximum number of users for this workspace.'
    else
      super do |resource|
        if resource.errors.empty?
          AccountMember.create!(user: resource, account: current_account, role: account_role)
          WorkspaceMember.create!(user: resource, workspace: current_workspace, workspace_role: workspace_role)
        end
      end
    end
  end

  def new
    self.resource = resource_class.new
    authorize resource, :invite?
    render :new
  end
end
