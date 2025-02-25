# frozen_string_literal: true

# == Schema Information
#
# Table name: communities
#
#  id          :integer          not null, primary key
#  color       :string           default("#53ea64"), not null
#  deleted_at  :datetime
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :integer
#
# Indexes
#
#  index_communities_on_account_id  (account_id)
#  index_communities_on_deleted_at  (deleted_at)
#
class Community < ApplicationRecord
  include Searchable
  include RandomColorAttribute
  include ExportToCsv

  has_paper_trail
  acts_as_paranoid

  belongs_to :account
  has_many :scorecards, dependent: :nullify

  validates :account, presence: true
  # TODO: Add validation to database, or remove this model completely
  validates :name, presence: true, uniqueness: { scope: :account_id } # rubocop:disable Rails/UniqueValidationWithoutIndex

  csv_attributes :name, :description, :color
end
