# frozen_string_literal: true

# == Schema Information
#
# Table name: initiatives
#
#  id               :integer          not null, primary key
#  archived_on      :datetime
#  contact_email    :string
#  contact_name     :string
#  contact_phone    :string
#  contact_position :string
#  contact_website  :string
#  dates_confirmed  :boolean
#  deleted_at       :datetime
#  description      :string
#  finished_at      :date
#  linked           :boolean          default(FALSE)
#  name             :string
#  old_notes        :text
#  started_at       :date
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  scorecard_id     :integer
#
# Indexes
#
#  index_initiatives_on_archived_on   (archived_on)
#  index_initiatives_on_deleted_at    (deleted_at)
#  index_initiatives_on_finished_at   (finished_at)
#  index_initiatives_on_name          (name)
#  index_initiatives_on_scorecard_id  (scorecard_id)
#  index_initiatives_on_started_at    (started_at)
#
# rubocop:disable Metrics/ClassLength
class Initiative < ApplicationRecord
  has_paper_trail
  acts_as_paranoid

  belongs_to :scorecard, optional: true
  has_many :initiatives_organisations, dependent: :destroy
  has_many :initiatives_subsystem_tags, dependent: :destroy
  has_many :organisations, through: :initiatives_organisations
  has_many :subsystem_tags, through: :initiatives_subsystem_tags
  has_many :checklist_items, dependent: :destroy
  has_many :characteristics, through: :checklist_items

  has_rich_text :notes

  accepts_nested_attributes_for :initiatives_organisations,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes['organisation_id'].blank? }

  accepts_nested_attributes_for :initiatives_subsystem_tags,
                                allow_destroy: true,
                                reject_if: proc { |attributes| attributes['subsystem_tag_id'].blank? }

  validates :name, presence: true
  validate :validate_finished_at_not_earlier_than_started_at

  after_create :create_missing_checklist_items!

  delegate :name, to: :scorecard, prefix: true
  delegate :name, to: :linked_initiative, prefix: true, allow_nil: true

  scope :incomplete,
        lambda {
          joins(:checklist_items).where('checklist_items.checked is NULL or checklist_items.checked = false').distinct
        }

  scope :archived,
        lambda {
          where.not(archived_on: nil).where('archived_on <= ?', Time.zone.now)
        }

  scope :not_archived,
        lambda {
          where(archived_on: nil).or(where('archived_on > ?', Time.zone.now))
        }

  # SMELL Lazy way
  scope :complete,
        lambda {
          where.not(id: Initiative.incomplete.pluck(:id))
        }

  scope :overdue,
        lambda {
          finished_at = Initiative.arel_table[:finished_at]
          incomplete.where(finished_at.lt(Date.today)).where(dates_confirmed: true)
        }

  scope :transition_cards,
        lambda {
          joins(:scorecard).where('scorecards.type': 'TransitionCard')
        }

  scope :sdgs_alignment_cards,
        lambda {
          joins(:scorecard).where('scorecards.type': 'SustainableDevelopmentGoalAlignmentCard')
        }

  def checklist_items_ordered_by_ordered_focus_area(selected_date: nil, focus_areas: nil)
    checklist_items = ChecklistItem
                      .includes(
                        :initiative,
                        :checklist_item_comments,
                        characteristic: [
                          :video_tutorial,
                          {
                            focus_area: [
                              :video_tutorial,
                              { focus_area_group: :video_tutorial }
                            ]
                          }
                        ]
                      ).where(
                        'checklist_items.initiative_id' => id,
                        'focus_area_groups_focus_areas_2.scorecard_type' => scorecard.type
                      ).order(
                        'focus_area_groups_focus_areas_2.position',
                        'focus_areas_characteristics.position',
                        'characteristics.position'
                      ).all

    if focus_areas.present?
      checklist_items =
        checklist_items.select do |checklist_item|
          checklist_item.focus_area.id.in?(focus_areas.map(&:id))
        end
    end

    if selected_date.present?
      checklist_items =
        checklist_items.map do |checklist_item|
          checklist_item.snapshot_at(selected_date.end_of_day)
        end
    end

    checklist_items
  end

  def archived?
    archived_on.present? && archived_on <= Time.zone.now
  end

  def linked_initiative
    return unless linked?
    return unless scorecard.linked_scorecard.present?

    scorecard.linked_scorecard.initiatives.find_by(name:)
  end

  def wicked_problem_name
    scorecard.try(:wicked_problem).try(:name)
  end

  def copy
    copied = dup
    organisations.each do |organisation|
      copied.initiatives_organisations.build(organisation:)
    end
    copied.save!

    copied
  end

  def create_missing_checklist_items!
    missing_characteristic_ids =
      Characteristic.per_scorecard_type_for_account(
        scorecard.type,
        scorecard.account
      ).pluck(:id) - checklist_items.map(&:characteristic_id)

    return if missing_characteristic_ids.empty?

    ChecklistItem.insert_all(
      missing_characteristic_ids.map do |characteristic_id|
        {
          initiative_id: id,
          characteristic_id:,
          created_at: Time.zone.now,
          updated_at: Time.zone.now
        }
      end
    )
  end

  private

  def validate_finished_at_not_earlier_than_started_at
    errors.add(:finished_at, "can't be earlier than started at date") unless finished_at_not_earlier_than_started_at
  end

  def finished_at_not_earlier_than_started_at
    return true unless started_at.present? && finished_at.present?

    finished_at >= started_at
  end
end
# rubocop:enable Metrics/ClassLength
