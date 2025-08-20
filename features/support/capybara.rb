# frozen_string_literal: true

# Capybara and Cuprite configuration for Cucumber
require 'capybara/cucumber'
require 'capybara/cuprite'

# Configure Capybara to use Cuprite (Chrome/Chromium driver)
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1200, 800],
    browser_options: {
      'no-sandbox': nil,
      'disable-gpu': nil,
      'disable-dev-shm-usage': nil,
      'disable-web-security': nil
    },
    inspector: ENV['INSPECTOR'] == 'true',
    headless: !ENV['HEADLESS'].in?([nil, '', '0', 'false'])
  )
end

# Set Cuprite as the JavaScript driver
Capybara.javascript_driver = :cuprite

# Configure Capybara settings
Capybara.configure do |config|
  config.default_max_wait_time = 10
  config.default_selector = :css
  config.default_driver = :rack_test

  # Set server host and port for CI environments
  config.server_host = '0.0.0.0' if ENV['CI']
  config.server_port = ENV.fetch('CAPYBARA_SERVER_PORT', 3001)

  # Configure app host for system tests
  config.app_host = "http://#{config.server_host}:#{config.server_port}" if ENV['CI']
end

# Switch to Cuprite driver for JavaScript scenarios
Before('@javascript') do
  Capybara.current_driver = :cuprite
end

After('@javascript') do
  Capybara.use_default_driver
end
