# frozen_string_literal: true

# == Schema Information
#
# Table name: characteristics
#
#  id            :integer          not null, primary key
#  code          :string
#  color         :string
#  deleted_at    :datetime
#  description   :string
#  name          :string
#  position      :integer
#  short_name    :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  focus_area_id :integer
#
# Indexes
#
#  index_characteristics_on_deleted_at              (deleted_at)
#  index_characteristics_on_focus_area_id           (focus_area_id)
#  index_characteristics_on_focus_area_id_and_code  (focus_area_id,code) UNIQUE
#  index_characteristics_on_position                (position)
#
require 'rails_helper'

RSpec.describe Characteristic, type: :model do
  describe '#display_name' do
    let(:characteristic) { described_class.new(code: code, short_name: short_name, name: name) }

    context 'when both code and short_name are present' do
      let(:code) { 'ABC' }
      let(:short_name) { 'Shorty' }
      let(:name) { 'Full Name' }

      it 'joins code and short_name with a space' do
        expect(characteristic.display_name).to eq('ABC Shorty')
      end
    end

    context 'when only code is present' do
      let(:code) { 'XYZ' }
      let(:short_name) { nil }
      let(:name) { 'Full Name' }

      it 'returns code joined to name' do
        expect(characteristic.display_name).to eq('XYZ Full Name')
      end
    end

    context 'when only short_name is present' do
      let(:code) { nil }
      let(:short_name) { 'Solo' }
      let(:name) { 'Full Name' }

      it 'returns short_name' do
        expect(characteristic.display_name).to eq('Solo')
      end
    end

    context 'when neither code nor short_name are present' do
      let(:code) { nil }
      let(:short_name) { nil }
      let(:name) { 'Fallback Name' }

      it 'returns name' do
        expect(characteristic.display_name).to eq('Fallback Name')
      end
    end

    context 'when code and short_name are blank strings' do
      let(:code) { '' }
      let(:short_name) { '' }
      let(:name) { 'Fallback Name' }

      it 'returns name' do
        expect(characteristic.display_name).to eq('Fallback Name')
      end
    end

    context 'when code is present and short_name starts with code' do
      let(:code) { 'ABC' }
      let(:short_name) { 'ABC Shorty' }
      let(:name) { 'Full Name' }

      it 'removes code from the start of the result' do
        expect(characteristic.display_name).to eq('ABC Shorty')
      end
    end
  end
end
