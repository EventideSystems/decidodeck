# frozen_string_literal: true

Given('I am not logged in') do
  logout if defined?(logout)
end

Given('I visit the site using a domain containing {string}') do |domain_text|
  visit "https://#{domain_text}.example.com"
end

Given('I am visiting the Free SDG landing page') do
  visit 'https://free-sdg.example.com'
end

Then('I should see the Free SDG landing page') do
  expect(page).to have_content('Free SDG')
  expect(page).to have_selector('h1', text: /Free SDG/i)
end

Then('I should see information about the Free SDG programme') do
  expect(page).to have_content('Sustainable Development Goals')
end

Then('I should see a call to action to find out more') do
  expect(page).to have_link('find out more')
end
