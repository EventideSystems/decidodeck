# frozen_string_literal: true

class FixDataModelPositions < ActiveRecord::Migration[8.0]
  def up
    DataModel.find_each do |data_model|
      focus_area_group_position = (data_model.focus_area_groups.pluck(:position).compact.max || 0) + 1      
      
      data_model.focus_area_groups.each do |focus_area_group|

        if focus_area_group.position.nil?
          focus_area_group.update!(position: focus_area_group_position)
          focus_area_group_position += 1
        end

        focus_area_position = (focus_area_group.focus_areas.pluck(:position).compact.max || 0) + 1
        focus_area_group.focus_areas.each do |focus_area|
          if focus_area.position.nil?
            focus_area.update!(position: focus_area_position)
            focus_area_position += 1
          end

          characteristic_position = (focus_area.characteristics.pluck(:position).compact.max || 0) + 1
          focus_area.characteristics.each do |characteristic|
            if characteristic.position.nil?
              characteristic.update!(position: characteristic_position)
              characteristic_position += 1
            end
          end
        end
      end
    end
  end

  def down
    # NO OP
  end
end
