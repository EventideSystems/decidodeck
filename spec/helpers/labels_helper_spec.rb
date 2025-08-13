# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LabelsHelper, type: :helper do
  describe '#hex_to_rgb' do
    it 'converts hex color to rgb array' do # rubocop:disable RSpec/MultipleExpectations
      expect(helper.hex_to_rgb('#14b8a6')).to eq([20, 184, 166])
      expect(helper.hex_to_rgb('14b8a6')).to eq([20, 184, 166])
      expect(helper.hex_to_rgb('#000000')).to eq([0, 0, 0])
      expect(helper.hex_to_rgb('ffffff')).to eq([255, 255, 255])
    end

    it 'handles blank input' do # rubocop:disable RSpec/MultipleExpectations
      expect(helper.hex_to_rgb(nil)).to eq([0, 0, 0])
      expect(helper.hex_to_rgb('')).to eq([0, 0, 0])
    end

    it 'converts color names to rgb' do # rubocop:disable RSpec/ExampleLength,RSpec/MultipleExpectations
      expect(helper.hex_to_rgb('blue')).to eq([0, 0, 255])
      expect(helper.hex_to_rgb('teal')).to eq([20, 184, 166])
      expect(helper.hex_to_rgb('red')).to eq([255, 0, 0])
      expect(helper.hex_to_rgb('white')).to eq([255, 255, 255])
      expect(helper.hex_to_rgb('gray')).to eq([128, 128, 128])
      expect(helper.hex_to_rgb('grey')).to eq([128, 128, 128])
    end

    it 'is case-insensitive and trims whitespace' do # rubocop:disable RSpec/MultipleExpectations
      expect(helper.hex_to_rgb('  Blue  ')).to eq([0, 0, 255])
      expect(helper.hex_to_rgb('TEAL')).to eq([20, 184, 166])
    end
  end
end
