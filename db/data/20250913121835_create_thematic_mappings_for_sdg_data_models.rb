# frozen_string_literal: true

class CreateThematicMappingsForSDGDataModels < ActiveRecord::Migration[8.0]
  MAPPINGS = {
    1 =>  ["1.1", "1.2", "1.3", "1.4", "1.5", "2.1", "2.3", "3.8", "3.9", "6.1", "7.1", "7.2", "10.1", "10.4", "11.1", "11.2", "11.5", "13.1"],
    2 =>  ["2.1", "2.2", "2.3", "2.4", "2.5", "6.4", "12.3", "15.3", "15.6"],
    3 =>  ["2.2", "3.1", "3.2", "3.3", "3.4", "3.5", "3.6", "3.7", "3.8", "3.9", "6.1", "6.2", "6.3", "11.2", "11.5", "12.4"],
    4 =>  ["3.7", "4.1", "4.2", "4.3", "4.4", "4.5", "4.6", "4.7", "5.6", "12.8", "13.3"],
    5 =>  ["1.4", "2.2", "3.7", "4.1", "4.2", "4.3", "4.5", "4.6", "4.7", "5.1", "5.2", "5.3", "5.4", "5.5", "5.6", "6.2"],
    6 =>  ["3.9", "6.1", "6.2", "6.3", "6.4", "6.5", "6.6"],
    7 =>  ["3.9", "7.1", "7.2", "7.3", "12.5"],
    8 =>  ["2.3", "2.4", "4.4", "8.1", "8.2", "8.3", "8.4", "8.5", "8.6", "8.7", "8.8", "8.9", "8.10", "9.1", "9.2", "9.3", "14.7"],
    9 =>  ["9.1", "9.2", "9.3", "9.4", "9.5"],
    10 => ["1.3", "1.4", "2.3", "3.8", "4.5", "5.1", "5.4", "5.5", "6.1", "7.1", "8.8", "9.1", "10.1", "10.2", "10.3", "10.4", "10.5", "10.6", "10.7", "11.1", "11.7", "15.6", "16.8"],
    11 => ["3.6", "3.9", "6.1", "11.1", "11.2", "11.3", "11.4", "11.5", "11.6", "11.7"],
    12 => ["2.4", "4.7", "6.4", "7.2", "7.3", "8.4", "9.4", "11.2", "11.6", "12.1", "12.2", "12.3", "12.4", "12.5", "12.6", "12.7", "12.8", "14.1", "15.6"],
    13 => ["1.5", "2.4", "6.3", "13.1", "13.2", "13.3", "15.2"],
    14 => ["14.1", "14.2", "14.3", "14.4", "14.5", "14.6", "14.7"],
    15 => ["2.4", "2.5", "6.6", "15.1", "15.2", "15.3", "15.4", "15.5", "15.6", "15.7", "15.8", "15.9"],
    16 => ["4.7", "5.1", "5.2", "5.5", "8.7", "10.2", "10.3", "10.6", "11.3", "16.1", "16.2", "16.3", "16.4", "16.5", "16.6", "16.7", "16.8", "16.9", "16.10"]
  }

  def up
    DataModel.where(name: "Sustainable Development Goals and Targets").each do |data_model|
      next if ThematicMapping.where(data_model: data_model).exists?

      MAPPINGS.each do |sdg_goal_id, sdg_target_ids|
        focus_area = data_model.focus_areas.find_by(code: sdg_goal_id.to_s)
        next unless focus_area
        sdg_target_ids.each do |sdg_target_id|
          characteristic = data_model.characteristics.find_by(code: sdg_target_id)
          next unless characteristic
          ThematicMapping.create(data_model: data_model, focus_area: focus_area, characteristic: characteristic)
        end
      end
    end
  end

  def down
    data_model_ids = DataModel.where(name: "Sustainable Development Goals and Targets").ids
    ThematicMapping.where(data_model_id: data_model_ids).delete_all
  end
end
