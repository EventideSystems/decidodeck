# frozen_string_literal: true

# Discardable concern for models that use the discard gem
module Discardable
  extend ActiveSupport::Concern
  include Discard::Model

  included do
    self.discard_column = :deleted_at
  end
end
