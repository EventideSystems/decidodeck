# frozen_string_literal: true

# == Schema Information
#
# Table name: thematic_mappings
#
#  id                :bigint           not null, primary key
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  characteristic_id :bigint
#  data_model_id     :bigint
#  focus_area_id     :bigint
#
# Indexes
#
#  index_thematic_mappings_on_characteristic_id  (characteristic_id)
#  index_thematic_mappings_on_focus_area_id      (focus_area_id)
#
require 'rails_helper'

RSpec.describe ThematicMapping, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
