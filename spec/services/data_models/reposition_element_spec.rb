# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DataModels::RepositionElement, type: :service do
  let!(:element) { create(:focus_area_group, position: 2) }
  let!(:first_sibling) { create(:focus_area_group, position: 1) }
  let!(:second_sibling) { create(:focus_area_group, position: 3) }
  let!(:siblings) { [first_sibling, element, second_sibling] }
  let(:new_position) { 1 }

  describe '#call' do
    context 'when moving an element upwards to a new position' do
      it 'reorders the elements correctly' do # rubocop:disable RSpec/MultipleExpectations
        service = described_class.new(element: element, new_position: new_position, siblings: siblings)
        service.call

        expect(element.position).to eq(new_position)
        expect(first_sibling.position).to eq(2)
        expect(second_sibling.position).to eq(3)
      end
    end

    context 'when moving an element downwards to a new position' do
      let(:new_position) { 3 }

      it 'reorders the elements correctly' do # rubocop:disable RSpec/MultipleExpectations
        service = described_class.new(element: element, new_position: new_position, siblings: siblings)
        service.call

        expect(element.position).to eq(new_position)
        expect(first_sibling.position).to eq(1)
        expect(second_sibling.position).to eq(2)
      end
    end

    context 'when moving the first element downwards to a new position' do
      let(:element) { create(:focus_area_group, position: 1) }
      let!(:first_sibling) { create(:focus_area_group, position: 1) }
      let!(:second_sibling) { create(:focus_area_group, position: 3) }
      let!(:siblings) { [element, first_sibling, second_sibling] }
      let(:new_position) { 2 }

      it 'reorders the elements correctly' do # rubocop:disable RSpec/MultipleExpectations
        service = described_class.new(element: element, new_position: new_position, siblings: siblings)
        service.call

        expect(element.position).to eq(new_position)
        expect(first_sibling.position).to eq(1)
        expect(second_sibling.position).to eq(3)
      end
    end

    context 'when new position is the same as the current position' do
      let(:new_position) { 2 }

      it 'does not change the positions' do # rubocop:disable RSpec/MultipleExpectations
        service = described_class.new(element: element, new_position: new_position, siblings: siblings)
        service.call

        expect(element.position).to eq(2)
        expect(first_sibling.position).to eq(1)
        expect(second_sibling.position).to eq(3)
      end
    end

    context 'when new position is out of bounds' do
      pending "add some examples to (or delete) #{__FILE__}"
    end

    context 'when new element has not been persisted' do
      let(:element) { build(:focus_area_group, position: 2) }

      it 'reorders the elements correctly' do # rubocop:disable RSpec/MultipleExpectations
        service = described_class.new(element: element, new_position: new_position, siblings: siblings)
        service.call

        expect(element.position).to eq(new_position)
        expect(first_sibling.position).to eq(2)
        expect(second_sibling.position).to eq(3)
      end
    end
  end
end
