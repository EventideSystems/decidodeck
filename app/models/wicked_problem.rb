# frozen_string_literal: true

# == Schema Information
#
# Table name: wicked_problems
#
#  id          :integer          not null, primary key
#  color       :string           default("#8a2d8a"), not null
#  deleted_at  :datetime
#  description :string
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  account_id  :integer
#
# Indexes
#
#  index_wicked_problems_on_account_id  (account_id)
#  index_wicked_problems_on_deleted_at  (deleted_at)
#
class WickedProblem < ApplicationRecord
  include Searchable
  include RandomColorAttribute
  include ExportToCsv

  has_paper_trail
  acts_as_paranoid

  belongs_to :account
  has_many :scorecards, dependent: :restrict_with_error

  validates :account, presence: true
  # TODO: Add validation to datbase schema
  validates :name, presence: true, uniqueness: { scope: :account_id } # rubocop:disable Rails/UniqueValidationWithoutIndex

  csv_attributes :name, :description, :color
end
