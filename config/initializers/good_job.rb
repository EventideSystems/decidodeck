ActionMailer::MailDeliveryJob.retry_on StandardError, wait: :polynomially_longer, attempts: Float::INFINITY

# With Sentry (or Bugsnag, Airbrake, Honeybadger, etc.)
ActionMailer::MailDeliveryJob.around_perform do |_job, block|
  block.call
rescue StandardError => e
  Rails.error.report(e)
  raise
end