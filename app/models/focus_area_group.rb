# frozen_string_literal: true

# == Schema Information
#
# Table name: focus_area_groups
#
#  id                        :integer          not null, primary key
#  code                      :string
#  color                     :string
#  deleted_at                :datetime
#  deprecated_scorecard_type :string           default("TransitionCard")
#  description               :string
#  name                      :string
#  position                  :integer
#  short_name                :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  data_model_id             :bigint
#  deprecated_workspace_id   :bigint
#
# Indexes
#
#  index_focus_area_groups_on_data_model_id              (data_model_id)
#  index_focus_area_groups_on_data_model_id_and_code     (data_model_id,code) UNIQUE
#  index_focus_area_groups_on_deleted_at                 (deleted_at)
#  index_focus_area_groups_on_deprecated_scorecard_type  (deprecated_scorecard_type)
#  index_focus_area_groups_on_deprecated_workspace_id    (deprecated_workspace_id)
#  index_focus_area_groups_on_position                   (position)
#
# Foreign Keys
#
#  fk_rails_...  (data_model_id => data_models.id)
#  fk_rails_...  (deprecated_workspace_id => workspaces.id)
#
class FocusAreaGroup < ApplicationRecord
  include RandomColorAttribute
  include ValidateUniqueCode
  include DataElementable

  acts_as_paranoid

  default_scope { order(:position) }

  # TODO: Remove 'optional: true' when all focus_area_groups have an impact card data model
  belongs_to :data_model, optional: true

  has_many :focus_areas, dependent: :destroy

  validates :position, presence: true # TODO: Scope uniqueness to data_model

  delegate :workspace, to: :data_model, allow_nil: true

  # Required by the DataElementable concern
  alias children focus_areas
  alias parent data_model
end
