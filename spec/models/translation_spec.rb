# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Translation, type: :model do
  context 'when scope is nil' do
    it 'is valid with locale, key, and value' do
      translation = described_class.new(locale: 'en', key: 'greeting', value: 'Hello')
      expect(translation).to be_valid
    end

    it 'is invalid without locale' do # rubocop:disable RSpec/MultipleExpectations
      translation = described_class.new(key: 'greeting', value: 'Hello')
      expect(translation).not_to be_valid
      expect(translation.errors[:locale]).to include("can't be blank")
    end

    it 'is invalid without key' do # rubocop:disable RSpec/MultipleExpectations
      translation = described_class.new(locale: 'en', value: 'Hello')
      expect(translation).not_to be_valid
      expect(translation.errors[:key]).to include("can't be blank")
    end

    it 'is invalid without value' do # rubocop:disable RSpec/MultipleExpectations
      translation = described_class.new(locale: 'en', key: 'greeting')
      expect(translation).not_to be_valid
      expect(translation.errors[:value]).to include("can't be blank")
    end

    it 'allows duplicate keys for different locales' do
      described_class.create!(locale: 'en', key: 'greeting', value: 'Hello')
      translation = described_class.new(locale: 'fr', key: 'greeting', value: 'Bonjour')
      expect(translation).to be_valid
    end

    it 'allows duplicate keys for different scopes' do
      account1 = Account.create!(name: 'Account 1')
      account2 = Account.create!(name: 'Account 2')
      described_class.create!(locale: 'en', key: 'greeting', value: 'Hello', scope: account1.i18n_scope)
      translation = described_class.new(locale: 'en', key: 'greeting', value: 'Hi', scope: account2.i18n_scope)
      expect(translation).to be_valid
    end

    it 'returns correct translation when scope changes' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      account = Account.create!(name: 'Account 1')
      described_class.create!(locale: 'en', key: 'greeting', value: 'Hello')
      described_class.create!(locale: 'en', key: 'greeting', value: 'Hi', scope: account.i18n_scope)

      I18n::Backend::ActiveRecord.config.scope = account.i18n_scope
      expect(I18n.t('greeting', locale: 'en')).to eq('Hi')

      I18n.backend.reload!

      I18n::Backend::ActiveRecord.config.scope = nil
      expect(I18n.t('greeting', locale: 'en')).to eq('Hello')
    end

    it 'returns nested translations correctly' do # rubocop:disable RSpec/MultipleExpectations
      described_class.create!(locale: 'en', key: 'greetings.morning', value: 'Good morning')
      described_class.create!(locale: 'en', key: 'greetings.evening', value: 'Good evening')

      expect(I18n.t('greetings.morning', locale: 'en')).to eq('Good morning')
      expect(I18n.t('greetings.evening', locale: 'en')).to eq('Good evening')
    end

    it 'returns humanized model name' do
      expect do
        described_class.create!(locale: 'en', key: 'activerecord.models.account', value: 'Alt Account')
        I18n.backend.reload!
      end.to change { Account.model_name.human }.from('Account').to('Alt Account')
    end
  end
end
