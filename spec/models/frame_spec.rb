require 'rails_helper'

RSpec.describe Frame, type: :model do
  describe 'associations' do
    it 'belongs to a game' do
      association = described_class.reflect_on_association(:game)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to a player' do
      association = described_class.reflect_on_association(:player)
      expect(association.macro).to eq(:belongs_to)
    end
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(pending: 0, open: 1, completed: 2) }
  end

  describe 'callbacks' do
    describe 'before_update' do
      let(:game) { create(:game) }
      let(:player) { create(:player) }
      let(:frame) { create(:frame, game: game, player: player) }

      it 'sets strike if all pins are knocked down in the first throw' do
        frame.update(pins_knocked_down_by_first_throw: 10)
        expect(frame.strike).to be_truthy
      end

      it 'sets spare if the sum of pins knocked down in two throws equals 10' do
        frame.update(pins_knocked_down_by_first_throw: 5, pins_knocked_down_by_second_throw: 5)
        expect(frame.spare).to be_truthy
      end

      it 'sets bonus_throw_pins for the previous frame if applicable' do
        frame.update(pins_knocked_down_by_first_throw: 10, strike: true, status: 2)
        next_frame = create(:frame, game: game, player: player, frame_number: (frame.frame_number+1))
        next_frame.update(pins_knocked_down_by_first_throw: 5, pins_knocked_down_by_second_throw: 3)
        frame.reload
        expect(frame.total_score).to eq(18)
        expect(frame.bonus_throw_pins).to eq(8)
      end
    end

    describe 'after_update' do
      let(:game) { create(:game) }
      let(:player) { create(:player) }
      let(:frame) { create(:frame, game: game, player: player, frame_number: 10, status: :completed) }

      it 'updates the game status to completed after the last frame' do
        expect(game.status).to eq('initiated')
        frame.update(status: :completed)
        game.reload
        expect(game.status).to eq('completed')
      end
    end
  end

  describe '#total_score' do
    let(:frame) { create(:frame, pins_knocked_down_by_first_throw: 5, pins_knocked_down_by_second_throw: 3) }

    it 'calculates the total score for the frame' do
      expect(frame.total_score).to eq(8)
    end

    it 'returns 0 if pins_knocked_down_by_first_throw is nil' do
      frame.update(pins_knocked_down_by_first_throw: nil)
      expect(frame.total_score).to eq(0)
    end
  end

  describe '#update_frame_status' do
    let(:frame) { create(:frame, pins_knocked_down_by_first_throw: 5, status: 'open') }

    it 'updates the status of the frame' do
      frame.update(pins_knocked_down_by_second_throw: 3)
      expect(frame.status).to eq('completed')
    end

    it 'sets status to open if pins_knocked_down_by_second_throw is nil' do
      expect(frame.status).to eq('open')
    end

    it 'sets status to completed if frame can be closed' do
      frame.update(frame_number: 10, pins_knocked_down_by_first_throw: 10, pins_knocked_down_by_second_throw: 10, bonus_throw_pins: 10)
      expect(frame.status).to eq('completed')
    end
  end

  describe '#can_closed?' do
    let(:frame) { create(:frame, pins_knocked_down_by_first_throw: 5) }

    it 'returns false if frame number is 10 and bonus_throw_pins is nil' do
      frame.update(frame_number: 10)
      expect(frame.send(:can_closed?)).to be_falsey
    end

    it 'returns true if strike is true' do
      frame.update(pins_knocked_down_by_first_throw: 10)
      expect(frame.send(:can_closed?)).to be_truthy
    end

    it 'returns true if spare is true' do
      frame.update(status: 'open', pins_knocked_down_by_first_throw: 5, pins_knocked_down_by_second_throw: 5)
      expect(frame.send(:can_closed?)).to be_truthy
    end

    it 'returns true if frame number is not 10 and pins_knocked_down_by_second_throw is present' do
      frame.update(status: 'open', pins_knocked_down_by_second_throw: 3)
      expect(frame.send(:can_closed?)).to be_truthy
    end

    it 'returns true if frame number is 10 and bonus_throw_pins is present' do
      frame.update(frame_number: 10, bonus_throw_pins: 5)
      expect(frame.send(:can_closed?)).to be_truthy
    end
  end
end
