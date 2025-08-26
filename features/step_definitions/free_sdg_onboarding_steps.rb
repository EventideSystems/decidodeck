# frozen_string_literal: true

When('I click the "Get Started" link') do
  click_link('Get Started')
end

When('I enter my registration details and submit the form') do
  fill_in 'Email', with: 'testuser@example.com'
  fill_in 'Password', with: 'password123'
  fill_in 'Password confirmation', with: 'password123'
  click_button 'Sign up'
end

And('I wait for registration form to load') do
  expect(page).to have_selector('form#new_user')
end

Then('I should receive an email asking me to confirm my registration') do
  message = ActionMailer::Base.deliveries.last

  expect(message.to).to include('testuser@example.com')
  expect(message.subject).to match(/confirmation/i)
end

Given('I have registered a Free SDG user account') do
  visit new_user_registration_path(theme: 'free-sdg')
  fill_in 'Email', with: 'testuser@example.com'
  fill_in 'Password', with: 'password123'
  fill_in 'Password confirmation', with: 'password123'
  click_button 'Sign up'
end

Given('I have confirmed my Free SDG user account') do
  @user = User.find_by(email: 'testuser@example.com')
  @user.confirm
end

When('I sign in for the first time') do
  visit new_user_session_path
  fill_in 'Email', with: 'testuser@example.com'
  fill_in 'Password', with: 'password123'
  click_button 'Sign in'
end

Then('I will be presented with a welcome message') do
  expect(page).to have_content(/Welcome to the '(.*)' workspace/)
end

When('I visit the stakeholder types page') do
  visit labels_stakeholder_types_path
end

When('I visit the library page') do
  visit data_models_path
end

Then('I will see a list of default stakeholder types') do
  expect(page).to have_content('Stakeholder Types')
  expect(page).to have_content('Business')
  expect(page).to have_content('Education')
  expect(page).to have_content('Federal government')
end

When('I should see a link to {string}') do |string|
  expect(page).to have_link(string)
end

When('I should not see a link to any other data models') do
  expect(page).to have_no_link("Lewin's Change Management Model")
end
