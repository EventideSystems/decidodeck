# frozen_string_literal: true

# == Schema Information
#
# Table name: artifacts
#
#  id            :integer
#  artifact_type :text
#  deleted_at    :datetime
#  description   :string
#  name          :string
#  created_at    :datetime
#  updated_at    :datetime
#  workspace_id  :integer
#
require 'rails_helper'

RSpec.describe Artifact, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
