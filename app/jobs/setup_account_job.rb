# Set up a new account for a user after sign-up
class SetupAccountJob < ApplicationJob
  queue_as :default

  def perform(user_id:, subscription_type: 'free_sdg')
    user = User.find_by(id: user_id)
    return if user.blank?

    account = Account.create(owner: user, subscription_type:, max_impact_cards: 2, max_users: 2)
    account.account_members.create(user:, role: 'admin')
    account.reload.default_workspace.tap do |workspace|
      workspace.workspace_members.create(user:, role: 'admin')
      SetupWorkspace.call(workspace:)
    end
  end
end
