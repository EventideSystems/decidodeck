# frozen_string_literal: true

# Interceptor to modify outgoing emails in non-production environments
# to prevent accidental delivery to real users.
# It prepends "[SAND BOX]" to the email subject and redirects all emails
# to a specified sandbox email address.
# The sandbox email address should be set in the environment variable
# SANDBOX_EMAIL_ADDRESS, which can contain multiple comma-separated addresses.
class SandboxEmailInterceptor
  def self.delivering_email(message)
    # Modify the email message here
    message.subject = "[SAND BOX] #{message.subject}"
    message.to = sandbox_email_address
  end

  def self.sandbox_email_address
    ENV.fetch('SANDBOX_EMAIL_ADDRESS').split(',').map(&:strip)
  end
end
