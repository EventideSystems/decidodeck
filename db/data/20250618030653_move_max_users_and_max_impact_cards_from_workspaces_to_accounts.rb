# frozen_string_literal: true

class MoveMaxUsersAndMaxImpactCardsFromWorkspacesToAccounts < ActiveRecord::Migration[8.0]
  def up
    Account.find_each do |account|      
      account.update(max_users: max_users(account), max_impact_cards: max_impact_cards(account))
    end
  end

  def down
    # NO OP
  end

  private

  def max_users(account)
    return 0 if account.workspaces.any? { |workspace| workspace.max_users.zero? }
      
    account.workspaces.map(&:max_users).max || 1
  end

  def max_impact_cards(account)
    return 0 if account.workspaces.any? { |workspace| workspace.max_scorecards.zero? }

    account.workspaces.map(&:max_scorecards).max || 1
  end
end
