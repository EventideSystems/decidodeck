# frozen_string_literal: true

# Helper methods for accounts
module AccountsHelper
  def account_badge(account)
    return '' if account.blank?

    badge_class = account_badge_class(account.subscription_type)
    created_at = account.created_at.strftime('%b. %Y')

    content_tag(:span, account.name, class: badge_class, title: "Created #{created_at}")
  end

  def account_subscription_type_badge(account)
    return '' if account.blank?

    badge_class = account_badge_class(account.subscription_type)
    badge_type_title = account.subscription_type.titleize

    content_tag(:span, badge_type_title, class: badge_class, title: "Subscription Type: #{badge_type_title}")
  end

  def options_for_default_workspace_grid_mode
    Account.default_workspace_grid_modes.keys.map do |mode|
      [mode.titleize, mode]
    end
  end

  def options_for_account_roles_select
    roles = AccountMember.roles
    options_for_select(AccountMember.roles.keys.map { |role| [role.capitalize, role] }, roles.keys.first)
  end

  private

  ACCOUNT_BADGE_BASE_CLASS = 'inline-flex items-center gap-x-1.5 rounded-md px-1.5 py-0.5 text-sm/5 font-medium sm:text-xs/5 forced-colors:outline text-black'

  private_constant :ACCOUNT_BADGE_BASE_CLASS

  def account_badge_class(subscription_type)
    case subscription_type.to_sym
    when :invoiced
      "#{ACCOUNT_BADGE_BASE_CLASS} bg-blue-400"
    when :free
      "#{ACCOUNT_BADGE_BASE_CLASS} bg-green-400"

    else
      "#{ACCOUNT_BADGE_BASE_CLASS} bg-gray-400"
    end
  end
end
