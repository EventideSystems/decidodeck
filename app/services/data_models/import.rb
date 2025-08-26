# frozen_string_literal: true

module DataModels
  # Load data model from YAML file into workspace. If no workspace given, model is assumed to be public (system) model
  class Import
    attr_reader :filename, :workspace

    def initialize(filename:, workspace: nil)
      @filename = filename
      @workspace = workspace
    end

    def self.call(filename:, workspace: nil)
      new(filename:, workspace:).call
    end

    def call # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      file = File.read(filename)
      source = YAML.load(file).with_indifferent_access

      ActiveRecord::Base.transaction do
        data_model = find_or_create_data_model(source)
        data_model.focus_area_groups.update_all(position: nil) # rubocop:disable Rails/SkipsModelValidations

        source[:goals].each_with_index do |goal_source, goal_position|
          goal = find_or_create_goal(data_model, goal_source, goal_position + 1)
          goal.focus_areas.update_all(position: nil) # rubocop:disable Rails/SkipsModelValidations

          goal_source[:targets].each_with_index do |target_source, target_position|
            target = find_or_create_target(goal, target_source, target_position + 1)
            target.characteristics.update_all(position: nil) # rubocop:disable Rails/SkipsModelValidations

            target_source[:indicators].each_with_index do |indicator_source, indicator_position|
              target.characteristics.find_or_create_by(name: indicator_source[:name]) do |indicator|
                update_element!(indicator, indicator_source, indicator_position + 1)
              end
            end
          end
        end
      end
    end

    private

    def data_model_params
      params = workspace.nil? ? {} : { workspace: workspace }
      params.merge(public_model: public_model?)
    end

    def find_or_create_data_model(data_model_source)
      DataModel.where(data_model_params).find_or_create_by(name: data_model_source[:name]) do |model|
        model.description = data_model_source[:description]
        model.license = data_model_source[:license]
        model.author = data_model_source[:author]
        model.public_model = public_model?
        model.workspace = workspace
        model.save!
      end
    end

    def find_or_create_goal(data_model, goal_source, position)
      data_model.focus_area_groups.find_or_create_by(name: goal_source[:name]) do |goal|
        update_element!(goal, goal_source, position)
      end
    end

    def find_or_create_target(goal, target_source, position)
      goal.focus_areas.find_or_create_by(name: target_source[:name]) do |target|
        update_element!(target, target_source, position)
      end
    end

    def public_model?
      workspace.nil?
    end

    def update_element!(element, source, position)
      attributes = source.slice(:code, :short_name, :description, :color).compact

      element.assign_attributes(attributes)
      element.position = position

      element.save!
    end
  end
end
