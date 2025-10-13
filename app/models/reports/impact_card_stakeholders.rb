# frozen_string_literal: true

require 'csv'

module Reports
  # This class is responsible for generating a report for the stakeholders of an impact card
  class ImpactCardStakeholders < Base # rubocop:disable Metrics/ClassLength
    attr_accessor :scorecard,
                  :unique_organisations,
                  :initiatives,
                  :stakeholder_types,
                  :ecosystem_map

    def initialize(scorecard)
      super()
      @scorecard = scorecard
      @stakeholder_types = StakeholderType.where(workspace: scorecard.workspace).order('lower(stakeholder_types.name)')
      @initiatives = fetch_initiatives(scorecard)
      @ecosystem_map = Insights::StakeholderNetwork.new(scorecard)
      @connections = OrganisationConnections.execute(scorecard.id)
      @unique_organisations = @scorecard.unique_organisations
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def to_xlsx
      with_i18n_scope(scope: scorecard.account.i18n_scope) do
        Axlsx::Package.new do |p|
          p.workbook.styles.fonts.first.name = 'Calibri'
          styles = default_styles(p)

          p.workbook.add_worksheet(name: 'Report') do |sheet|
            sheet.add_row([DateTime.now], style: styles[:date])
            add_title(sheet, styles)
            sheet.add_row
            add_summary(sheet, styles)
            sheet.add_row
            add_unique_organisations(sheet, styles)
            sheet.add_row
            add_initiatives(sheet, styles)
            sheet.add_row
            add_stakeholder_types(sheet, styles)
          end
        end.to_stream
      end
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    private

    def fetch_initiatives(scorecard)
      scorecard.initiatives.not_archived.includes(
        organisations: :stakeholder_type,
        initiatives_organisations: :organisation
      ).order('lower(initiatives.name)')
    end

    def scorecard_model_name
      scorecard.data_model.name
    end

    def add_summary(sheet, styles)
      sheet.add_row(
        ["Total Partnering #{Organisation.model_name.human.pluralize.titleize}",
         total_partnering_organisations], style: styles[:h1]
      )
      sheet.add_row(
        ["Total #{scorecard_model_name} #{Initiative.model_name.human.pluralize.titleize}",
         total_transition_card_initiatives],
        style: styles[:h1]
      )
    end

    def add_initiatives(sheet, styles) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      sheet.add_row(
        [
          Initiative.model_name.human.pluralize.titleize,
          "Total #{Organisation.model_name.human.pluralize.titleize}",
          Organisation.model_name.human.pluralize.titleize
        ], style: styles[:h3]
      )
      initiatives.each do |initiative|
        name = initiative.name
        organisations = organisations_for_initiative(initiative)
        organisations_names = organisations.map(&:name)
        total_organisations = organisations.count

        sheet.add_row([name, total_organisations] + organisations_names)
      end
    end

    def add_stakeholder_types(sheet, styles) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      sheet.add_row(
        [
          StakeholderType.model_name.human.titleize,
          "Total #{Organisation.model_name.human.pluralize.titleize}",
          Organisation.model_name.human.pluralize.titleize
        ], style: styles[:h3]
      )
      stakeholder_types.each do |stakeholder_type|
        name = stakeholder_type.name
        organisations = organisations_for_stakeholder_type(stakeholder_type)
        organisations_names = organisations.map(&:name)
        total_organisations = organisations.count

        sheet.add_row([name, total_organisations] + organisations_names)
      end
    end

    def add_title(sheet, styles)
      sheet.add_row([scorecard_model_name], style: styles[:h1]).add_cell(scorecard.name, style: styles[:blue_normal])
      sheet.add_row(['Problem / opportunity', scorecard.wicked_problem&.name || 'NOT DEFINED'])
      sheet.add_row(['Community', scorecard.community&.name || 'NOT DEFINED'])
    end

    def organisation_section_headers
      [
        Organisation.model_name.human.pluralize.titleize,
        'Betweenness Centrality',
        'Total Connections',
        "Total #{Initiative.model_name.human.pluralize.titleize}",
        StakeholderType.model_name.human.titleize,
        Initiative.model_name.human.pluralize.titleize
      ]
    end

    def add_unique_organisations(sheet, styles) # rubocop:disable Metrics/AbcSize,Metrics/CyclomaticComplexity,Metrics/MethodLength
      sheet.add_row(organisation_section_headers, style: styles[:h3])

      unique_organisations.each do |organisation|
        name = organisation.name
        initiatives = initiatives_for_organisation(organisation)
        initiatives_names = initiatives.map(&:name)
        total_initiatives = initiatives.count
        stakeholder_type = organisation.stakeholder_type&.name || ''

        node = ecosystem_map.nodes.find { |candidate_node| candidate_node[:id] == organisation.id }
        betweenness = node[:betweenness] || 0.0
        connections = @connections[organisation.id] || 0

        sheet.add_row([name, betweenness, connections, total_initiatives, stakeholder_type] + initiatives_names)
      end
    end

    def total_partnering_organisations
      unique_organisations&.count || 0
    end

    def total_transition_card_initiatives
      scorecard.initiatives.not_archived.count
    end

    def initiatives_for_organisation(organisation)
      initiatives.select do |initiative|
        initiative.organisations.include?(organisation)
      end
    end

    def organisations_for_initiative(initiative)
      initiative.organisations.uniq.sort_by { |organisation| organisation.name.downcase }
    end

    def organisations_for_stakeholder_type(stakeholder_type)
      unique_organisations.select { |organisation| organisation.stakeholder_type == stakeholder_type }
    end
  end
end
