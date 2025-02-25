# frozen_string_literal: true

# == Schema Information
#
# Table name: subsystem_tags
#
#  id          :integer          not null, primary key
#  color       :string           default("#a04b50"), not null
#  deleted_at  :datetime
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :integer
#
# Indexes
#
#  index_subsystem_tags_on_account_id  (account_id)
#  index_subsystem_tags_on_deleted_at  (deleted_at)
#
class SubsystemTag < ApplicationRecord
  include Searchable
  include RandomColorAttribute
  include ExportToCsv

  has_paper_trail
  acts_as_paranoid

  belongs_to :account
  has_many :initiatives_subsystem_tags, dependent: :delete_all
  has_many :initiatives, through: :initiatives_subsystem_tags

  validates :account, presence: true
  # TODO: Add validation to database schema
  validates :name, presence: true, uniqueness: { scope: :account_id } # rubocop:disable Rails/UniqueValidationWithoutIndex

  alias_attribute :text, :name # TODO: Check if this is still required?

  csv_attributes :name, :description, :color
end
