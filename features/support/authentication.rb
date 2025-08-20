# frozen_string_literal: true

# Authentication helpers for Cucumber
require 'devise'

# Include Devise test helpers
World(Devise::Test::IntegrationHelpers)

# Include FactoryBot methods
World(FactoryBot::Syntax::Methods)

# Helper methods for authentication
module AuthenticationHelpers
  def sign_in_user(user = nil)
    user ||= create(:user)
    sign_in user
    user
  end

  def sign_out_current_user
    sign_out :user
  end

  def current_user_should_be_signed_in
    expect(page).not_to have_content('Sign In')
  end

  def current_user_should_be_signed_out
    expect(page).to have_content('Sign In')
  end
end

World(AuthenticationHelpers)
