# frozen_string_literal: true

Given('the {string} workspace has expired') do |string|
  @workspace = Workspace.find_by(name: string)
  @workspace.account.update!(expires_on: 1.day.ago)
end

Then('I will be prompted to renew my workspace') do
  expect(page.body).to match(%r{Please contact the\s*<a[^>]*>system administrators</a>\s*to renew your subscription\.})
end
