# frozen_string_literal: true

module Insights
  # This class is responsible for generating the data required to render the Organisations Network Map
  # for a given impact card.
  class StakeholderNetwork
    attr_reader :transition_card, :unique_organisations

    STRENGTH_BUCKET_SIZE = 4

    STRENGTH_BUCKET_WIDTH = 100.0 / STRENGTH_BUCKET_SIZE

    def initialize(transition_card)
      @transition_card = transition_card
      @unique_organisations = transition_card.organisations.includes(:stakeholder_type).uniq.sort_by do |organisation|
        organisation.name.downcase
      end
    end

    def links
      @links ||= build_links
    end

    def nodes
      @nodes ||= build_nodes
    end

    def link_data
      @link_data ||= build_link_data
    end

    private

    def build_link_data # rubocop:disable Metrics/MethodLength
      query = <<~SQL
        select org1.id, org2.id
        from initiatives
        inner join scorecards on scorecards.id = initiatives.scorecard_id
        inner join initiatives_organisations io1 on io1.initiative_id = initiatives.id
        inner join organisations org1 on org1.id = io1.organisation_id
        inner join initiatives_organisations io2 on io2.initiative_id = initiatives.id
        inner join organisations org2 on org2.id = io2.organisation_id
        where org1.id <> org2.id and initiatives.scorecard_id = #{transition_card.id}
        and (initiatives.archived_on > now() or initiatives.archived_on is null)
      SQL

      results = ActiveRecord::Base.connection.exec_query(query).rows

      results.map(&:minmax)
    end

    def build_betweenness(link_data)
      links = link_data.uniq

      lambda = Aws::Lambda::Client.new(region: 'us-west-2', http_read_timeout: 300)
      response = lambda.invoke(function_name: 'betweennessCentrality', payload: { 'links' => links }.to_json)

      payload = JSON.parse(response.payload.read)
      # SMELL: This is a temporary fix. Large datasets are taking too long to return and timing out.
      data = JSON.parse(payload['body'].presence || '{}')

      data.transform_keys(&:to_i)
    rescue Exception # rubocop:disable Lint/RescueException
      raise(payload.inspect)
    end

    def build_links # rubocop:disable Metrics/MethodLength
      grouped_link_data = link_data.group_by(&:itself).transform_values(&:count)

      upper = grouped_link_data.values.max
      lower = grouped_link_data.values.min

      grouped_link_data.map do |(target, source), link_count|
        {
          id: target,
          target:,
          source:,
          strength: calc_strength(upper, lower, link_count)
        }
      end
    end

    def build_nodes
      betweenness = build_betweenness(link_data)

      unique_organisations.map do |node|
        {
          id: node.id,
          label: node.name,
          color: node.stakeholder_type&.color || '#808080',
          betweenness: betweenness[node.id]
        }
      end
    end

    def calc_strength(upper, lower, value)
      return 1 if upper == lower

      range = upper - lower
      value_in_range = value - lower

      base_strength = (
        ((value_in_range.to_f / range) * 100) / STRENGTH_BUCKET_WIDTH
      ).round

      base_strength.zero? ? 1 : base_strength
    end
  end
end
