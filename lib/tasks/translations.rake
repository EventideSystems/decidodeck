# frozen_string_literal: true
# 
namespace :translations do
  
  desc 'Create translation record for account'
  task create: :environment do
    account = Account.find_by(name: ENV['ACCOUNT_NAME'])
    unless account
      puts "Account with name '#{ENV['ACCOUNT_NAME']}' not found."
      exit 1
    end
    translation = Translation.new(
      locale: ENV['LOCALE'] || 'en',
      key: ENV['KEY'],
      value: ENV['VALUE'],
      scope: account.i18n_scope
    )
    if translation.save
      puts "Translation created: #{translation.inspect}"
    else
      puts "Failed to create translation: #{translation.errors.full_messages.join(', ')}"
      exit 1
    end
  end
end
