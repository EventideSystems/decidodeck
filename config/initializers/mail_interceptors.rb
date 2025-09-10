Rails.application.configure do
  if ENV['SANDBOX_EMAIL_ADDRESS'].present? && !Rails.env.production?
    config.action_mailer.interceptors = %w[SandboxEmailInterceptor]
  end
end
