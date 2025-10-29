# frozen_string_literal: true

# rubocop:disable Layout/LineLength
# == Schema Information
#
# Table name: data_models
#
#  id           :bigint           not null, primary key
#  author       :string
#  color        :string           default("#0d9488"), not null
#  deleted_at   :datetime
#  description  :string
#  license      :string
#  metadata     :jsonb
#  name         :string           not null
#  short_name   :string
#  status       :string           default("active"), not null
#  public_model :boolean          default(FALSE)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  workspace_id :bigint
#
# Indexes
#
#  index_data_models_on_name_and_workspace_id  (name,workspace_id) UNIQUE WHERE ((workspace_id IS NOT NULL) AND (deleted_at IS NULL))
#  index_data_models_on_workspace_id           (workspace_id)
#
# Foreign Keys
#
#  fk_rails_...  (workspace_id => workspaces.id)
#
# rubocop:enable Layout/LineLength
class DataModel < ApplicationRecord
  include Searchable

  include Discardable

  string_enum status: %i[active draft archived]

  belongs_to :workspace, optional: true
  has_many :focus_area_groups, dependent: :destroy
  has_many :focus_areas, through: :focus_area_groups
  has_many :characteristics, through: :focus_areas
  has_many :scorecards, dependent: :destroy
  has_many :initiatives, through: :scorecards
  has_many :thematic_mappings, dependent: :destroy

  validates :name, presence: true
  validates :name, uniqueness: { scope: :workspace_id }, if: -> { workspace_id.present? }

  alias children focus_area_groups

  def codes
    [focus_area_groups, focus_areas, characteristics]
      .flat_map(&:reload)
      .compact_blank
      .filter_map(&:code)
      .uniq
  end

  def display_name
    short_name.presence || name
  end

  def element_by_code(code)
    focus_area_groups.find_by(code: code) ||
      focus_areas.find_by(code: code) ||
      characteristics.find_by(code: code)
  end
end
