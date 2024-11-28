# frozen_string_literal: true

require 'csv'

module Reports
  class TransitionCardStakeholders < Base
    attr_accessor :scorecard,
                  :include_betweenness,
                  :unique_organisations,
                  :initiatives,
                  :stakeholder_types,
                  :ecosystem_map

    def initialize(scorecard, include_betweenness: false)
      super()
      @scorecard = scorecard
      @include_betweenness = include_betweenness

      @stakeholder_types = StakeholderType.where(account: scorecard.account).order('lower(stakeholder_types.name)')

      @initiatives =
        scorecard.initiatives.not_archived.includes(
          organisations: :stakeholder_type,
          initiatives_organisations: :organisation
        ).order('lower(initiatives.name)')

      @unique_organisations =
        @initiatives.flat_map(&:organisations).uniq.sort_by do |organisation|
          organisation.name.downcase
        end

      return unless include_betweenness

      @ecosystem_map = EcosystemMaps::Organisations.new(scorecard, unique_organisations: @unique_organisations)
      @connections = OrganisationConnections.execute(scorecard.id)
    end

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    def to_xlsx
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
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize

    private

    def scorecard_model_name
      case scorecard
      when TransitionCard
        scorecard.account.transition_card_model_name
      when SustainableDevelopmentGoalAlignmentCard
        scorecard.account.sdgs_alignment_card_model_name
      end
    end

    def add_summary(sheet, styles)
      sheet.add_row(['Total Partnering Organisations', total_partnering_organisations], style: styles[:h1])
      sheet.add_row(
        ["Total #{scorecard_model_name} Initiatives", total_transition_card_initiatives],
        style: styles[:h1]
      )
    end

    def add_initiatives(sheet, styles)
      sheet.add_row(['Initiatives', 'Total Organisations', 'Organisations'], style: styles[:h3])
      initiatives.each do |initiative|
        name = initiative.name
        organisations = organisations_for_initiative(initiative)
        organisations_names = organisations.map(&:name)
        total_organisations = organisations.count

        sheet.add_row([name, total_organisations] + organisations_names)
      end
    end

    def add_stakeholder_types(sheet, styles)
      sheet.add_row(['Stakeholder Type', 'Total Organisations', 'Organisations'], style: styles[:h3])
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
      sheet.add_row(['Wicked problem / opportunity', scorecard.wicked_problem&.name || 'MISSING DATA'])
      sheet.add_row(['Community', scorecard.community&.name || 'MISSING DATA'])
    end

    ORGANISTION_SECTION_HEADERS = {
      betweenness: [
        'Organisations',
        'Betweenness Centrality',
        'Total Connections',
        'Total Initiatives',
        'Stakeholder Type',
        'Initiatives'
      ],
      normal: [
        'Organisations',
        'Total Initiatives',
        'Stakeholder Type',
        'Initiatives'
      ]
    }.freeze

    def add_unique_organisations(sheet, styles)
      organisation_section_headers = ORGANISTION_SECTION_HEADERS[include_betweenness ? :betweenness : :normal]

      sheet.add_row(organisation_section_headers, style: styles[:h3])

      unique_organisations.each do |organisation|
        name = organisation.name
        initiatives = initiatives_for_organisation(organisation)
        initiatives_names = initiatives.map(&:name)
        total_initiatives = initiatives.count
        stakeholder_type = organisation.stakeholder_type&.name || ''

        if include_betweenness
          node = ecosystem_map.nodes.find { |node| node[:id] == organisation.id }
          betweenness = node[:betweenness] || 0.0
          connections = @connections[organisation.id] || 0

          sheet.add_row([name, betweenness, connections, total_initiatives, stakeholder_type] + initiatives_names)
        else
          sheet.add_row([name, total_initiatives, stakeholder_type] + initiatives_names)
        end
      end
    end

    def total_partnering_organisations
      unique_organisations.count
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
