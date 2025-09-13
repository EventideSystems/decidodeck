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
class ThematicMapping < ApplicationRecord
  belongs_to :focus_area
  belongs_to :characteristic
  belongs_to :data_model, optional: true
end
