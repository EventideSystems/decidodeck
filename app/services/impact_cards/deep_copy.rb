# frozen_string_literal: true

module ImpactCards
  # rubocop:disable Metrics/ClassLength,Style/Documentation,Metrics/AbcSize,Metrics/MethodLength,Metrics/BlockLength
  class DeepCopy
    attr_accessor :impact_card, :new_name, :target_account

    def self.call(impact_card:, new_name: nil, target_account: nil)
      new(impact_card:, new_name:, target_account:).call
    end

    def initialize(impact_card:, new_name: nil, target_account: nil)
      @impact_card = impact_card
      @new_name = new_name.presence || "#{impact_card.name} (copy)"
      @target_account = target_account.presence || impact_card.account
    end

    def call
      assert_valid_target_account!

      ActiveRecord::Base.transaction do
        copy_wicked_problem
        copy_community
        copy_subsystem_tags
        copy_stakeholders

        impact_card.dup.tap do |new_impact_card|
          new_impact_card.name = new_name
          new_impact_card.shared_link_id = impact_card.new_shared_link_id
          new_impact_card.wicked_problem = target_account.wicked_problems.find_by(name: impact_card.wicked_problem&.name)
          new_impact_card.community = target_account.communities.find_by(name: impact_card.community&.name)
          new_impact_card.account = target_account
          new_impact_card.save!

          copy_initiatives(impact_card, new_impact_card)
        end
      end
    end

    private

    # Ensure that the target account has a compatible data model
    def assert_valid_target_account!
      return if target_account == impact_card.account

      impact_card.account.focus_area_groups.where(scorecard_type: impact_card.type).find_each do |focus_area_group|
        target_group = find_target_focus_area_group(focus_area_group.name, impact_card.type)

        if target_group.blank?
          raise(ArgumentError, "Missing focus area group '#{focus_area_group.name}' in target account")
        end

        focus_area_group.focus_areas.each do |focus_area|
          target_area = target_group.focus_areas.find_by(name: focus_area.name)

          raise(ArgumentError, "Missing focus area '#{focus_area.name}' in target account") if target_area.blank?

          focus_area.characteristics.each do |characteristic|
            target_characteristic = target_area.characteristics.find_by(name: characteristic.name)

            next if target_characteristic.present?

            raise(ArgumentError, "Missing characteristic '#{characteristic.name}' in target account")
          end
        end
      end
    end

    # NOTE: We are using Initiative.where(scorecard: source_impact_card) to as the source of the initiatives to copy as
    # source_impact_card.initiatives will return the list ordered by name, which is not guaranteed to be the order in
    # which they appear in the grid. We need to maintain the order of the initiatives in the grid, otherwise we may
    # confuse users.
    def copy_initiatives(source_impact_card, target_impact_card)
      Initiative.where(scorecard: source_impact_card).find_each do |initiative|
        initiative.dup.tap do |new_initiative|
          new_initiative.scorecard = target_impact_card
          new_initiative.subsystem_tags = fetch_subsystem_tags(initiative)
          new_initiative.organisations = fetch_stakeholders(initiative)
          new_initiative.save!
          new_initiative.reload

          initiative.checklist_items.each do |checklist_item|
            next if checklist_item.status == 'no_comment'

            # TODO: Refactor this to use a more efficient method
            new_checklist_item =
              new_initiative.checklist_items.find do |item|
                item.characteristic.name == checklist_item.characteristic.name
              end

            new_checklist_item.update!(
              status: checklist_item.status,
              comment: checklist_item.comment,
              user: checklist_item.user,
              created_at: checklist_item.created_at,
              updated_at: checklist_item.updated_at
            )

            checklist_item.checklist_item_changes.each do |change|
              new_checklist_item.checklist_item_changes.create!(
                user: change.user,
                starting_status: change.starting_status,
                ending_status: change.ending_status,
                comment: change.comment,
                action: change.action,
                activity: change.activity,
                created_at: change.created_at
              )
            end
          end
        end
      end
    end

    def copy_stakeholders
      return if target_account == impact_card.account

      impact_card.organisations.uniq.each do |organisation|
        next if target_account.organisations.find_by(name: [organisation.name, organisation.name.strip])

        stakeholder_type = fetch_stakeholder_type(organisation.stakeholder_type)

        organisation.dup.tap do |new_organisation|
          new_organisation.name = organisation.name.strip
          new_organisation.account = target_account
          new_organisation.stakeholder_type = stakeholder_type
          new_organisation.save!
        end
      end
    end

    def copy_subsystem_tags
      return if target_account == impact_card.account

      impact_card.subsystem_tags.uniq.each do |tag|
        next if target_account.subsystem_tags.find_by(name: [tag.name, tag.name.strip])

        target_account.subsystem_tags.create!(name: tag.name.strip)
      end
    end

    def copy_wicked_problem
      return if target_account == impact_card.account

      wicked_problem = impact_card.wicked_problem

      return if target_account.wicked_problems.find_by(name: wicked_problem.name)

      wicked_problem.dup.tap do |new_wicked_problem|
        new_wicked_problem.account = target_account
        new_wicked_problem.save!
      end
    end

    def copy_community
      return if target_account == impact_card.account

      community = impact_card.community

      return if target_account.communities.find_by(name: community.name)

      community.dup.tap do |new_community|
        new_community.account = target_account
        new_community.save!
      end
    end

    def fetch_stakeholder_type(stakeholder_type)
      target_stakeholder_type = target_account.stakeholder_types.find_by(name: stakeholder_type.name)

      return target_stakeholder_type if target_stakeholder_type.present?

      stakeholder_type.dup.tap do |new_stakeholder_type|
        new_stakeholder_type.account = target_account
        new_stakeholder_type.save!
      end
    end

    def fetch_stakeholders(initiative)
      target_account.organisations.where(name: initiative.organisations.pluck(:name).map(&:strip))
    end

    def fetch_subsystem_tags(initiative)
      target_account.subsystem_tags.where(name: initiative.subsystem_tags.pluck(:name).map(&:strip))
    end

    def find_target_focus_area_group(name, scorecard_type)
      target_account.focus_area_groups.find_by(name:, scorecard_type:)
    end
  end
  # rubocop:enable Metrics/ClassLength,Style/Documentation,Metrics/AbcSize,Metrics/MethodLength,Metrics/BlockLength
end
