# frozen_string_literal: true

module Insights
  # This class is responsible for generating the data required to render the Thematic Network Map
  # for a given SDGs Card.
  #
  # It's all a bit of a mess at present, as the TargetsNetworkMapping only points to the original shared SDGs Card
  # model (i.e. focus area groups, areas and characteristics) and not the ones that are now duplicated across
  # workspaces.
  #
  # For now we'll use the original shared SDGs Card model to get the data we need and map it to the workspace's
  # duplicated models. NB This requires that the workspace's duplicated models are in sync with the original shared
  # SDGs Card model. If the names are ever changed, this will break.
  class TargetsNetwork # rubocop:disable Metrics/ClassLength
    attr_reader :transition_card, :targets_network_mappings

    def initialize(transition_card)
      @transition_card = transition_card
    end

    def links
      targets_network_mapping.map do |mapping|
        target = workspace_characteristics.find { |characteristic| characteristic.name == mapping.characteristic.name }
        source = workspace_focus_areas.find { |focus_area| focus_area.name == mapping.focus_area.name }

        {
          id: mapping.id,
          target: "characteristic-#{target.id}",
          source: "focus-area-#{source.id}"
        }
      end
    end

    # TODO: Add orgs to the nodes via the transition_card
    def nodes
      focus_area_nodes + characteristic_nodes
    end

    private

    def workspace_focus_areas
      @workspace_focus_areas ||=
        transition_card
        .data_model
        .focus_area_groups
        .includes(focus_areas: :characteristics)
        .flat_map(&:focus_areas)
    end

    def workspace_characteristics
      @workspace_characteristics ||= workspace_focus_areas.flat_map(&:characteristics)
    end

    def characteristics
      @characteristics ||=
        targets_network_mapping.map(&:characteristic).map do |characteristic|
          workspace_characteristics.find do |workspace_characteristic|
            workspace_characteristic.name == characteristic.name
          end
        end.uniq.compact
    end

    def focus_areas
      @focus_areas ||=
        targets_network_mapping.map(&:focus_area).map do |focus_area|
          workspace_focus_areas.find { |workspace_focus_area| workspace_focus_area.name == focus_area.name }
        end.uniq.compact
    end

    def focus_area_nodes # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      focus_areas.map do |node|
        mappings =
          organisations_and_intitiatives.select do |mapping|
            mapping[:focus_area_id] == node.id
          end

        # TODO: Move this into the SQL query
        organisation_ids = mappings.map { |hash| hash[:organisation_id] }
                                   .flatten.compact.uniq.map(&:to_s)

        stakeholders = Organisation.where(id: organisation_ids).order(:name).pluck(:name)

        initiative_ids = mappings.map { |hash| hash[:initiative_id] }
                                 .flatten.compact.uniq.map(&:to_s)

        initiatives = Initiative.where(id: initiative_ids).order(:name).pluck(:name)

        description = FocusArea.find(node.id).description.presence

        {
          id: "focus-area-#{node.id}",
          label: node.code || node.short_name,
          color: node.color,
          stakeholders:,
          initiatives:,
          description:,
          size: 13
        }
      end
    end

    def characteristic_nodes # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      characteristics.map do |node|
        mappings =
          organisations_and_intitiatives.select do |mapping|
            mapping[:characteristic_id] == node.id
          end

        # TODO: Move this into the SQL query
        organisation_ids = mappings.map { |hash| hash[:organisation_id] }
                                   .flatten.compact.uniq.map(&:to_s)

        stakeholders = Organisation.where(id: organisation_ids).order(:name).pluck(:name)

        initiative_ids = mappings.map { |hash| hash[:initiative_id] }
                                 .flatten.compact.uniq.map(&:to_s)

        initiatives = Initiative.where(id: initiative_ids).order(:name).pluck(:name)

        description = Characteristic.find(node.id).description

        {
          id: "characteristic-#{node.id}",
          label: node.short_name,
          color: node.focus_area.color,
          characteristic_id: node.id,
          stakeholders:,
          initiatives:,
          description:,
          size: 6
        }
      end
    end

    def organisations_and_intitiatives
      @organisations_and_intitiatives ||=
        ActiveRecord::Base.connection.execute(organisations_and_inititiatives_sql).map do |row|
          row.symbolize_keys.transform_values { |v| v.is_a?(String) ? v.gsub(/{|}|NULL/, '').split(',').compact : v }
        end
    end

    def organisations_and_inititiatives_sql
      <<~SQL
        with current_statuses as (
          select
            characteristics.id as characteristic_id,
            characteristics.focus_area_id as focus_area_id,
            checklist_items.id as checklist_item_id,
            checklist_items.status as status,
            initiatives.id as initiative_id
          from checklist_items
          inner join characteristics
            on characteristics.id = checklist_items.characteristic_id
          inner join initiatives
            on initiatives.id = checklist_items.initiative_id
          where initiatives.scorecard_id = #{transition_card.id}
          and (initiatives.archived_on > now() or initiatives.archived_on is null)
        )
        select
          characteristic_id,
          focus_area_id,
          array_agg(current_statuses.initiative_id) as initiative_id,
          array_agg(organisation_id) as organisation_id
        from current_statuses
        left join initiatives_organisations on initiatives_organisations.initiative_id = current_statuses.initiative_id
        where status = 'actual'
        group by characteristic_id, focus_area_id
      SQL
    end

    def targets_network_mapping
      @targets_network_mapping ||=
        TargetsNetworkMapping
        .where(data_model: transition_card.data_model)
        .includes(:focus_area, :characteristic)
        .all
    end
  end
end
