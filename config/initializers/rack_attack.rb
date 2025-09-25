# frozen_string_literal: true

Rack::Attack.blocklist('block all access to wp') do |request|
  # Block WP probes
  request.path.match?(/wp-(.*)/)
end
