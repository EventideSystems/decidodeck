require 'i18n/backend/active_record'

Translation = I18n::Backend::ActiveRecord::Translation

if Translation.table_exists?
  I18n.backend = I18n::Backend::ActiveRecord.new

  I18n::Backend::ActiveRecord.send(:include, I18n::Backend::Memoize)
  I18n::Backend::Simple.send(:include, I18n::Backend::Memoize)
  I18n::Backend::Simple.send(:include, I18n::Backend::Pluralization)

  I18n.backend = I18n::Backend::Chain.new(I18n.backend, I18n::Backend::Simple.new)
end

I18n::Backend::ActiveRecord.configure do |config|
  # config.cache_translations = true # defaults to false
  # config.cleanup_with_destroy = true # defaults to false
  # config.scope = 'app_scope' # defaults to nil, won't be used
end

I18n::Backend::ActiveRecord::Translation.class_eval do
  validates :locale, presence: true
  validates :key, presence: true
  validates :value, presence: true, unless: :is_proc?
  validates :scope, uniqueness: { scope: %i[locale key] }, allow_nil: true # rubocop:disable Rails/UniqueValidationWithoutIndex
end
