# frozen_string_literal: true

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
