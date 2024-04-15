require 'rails_helper'

RSpec.describe Player, type: :model do
  describe 'associations' do
    it { should have_many(:frames) }
  end

  describe '#total_score' do
    let(:player) { create(:player) }

    it 'returns 0 when player has no frames' do
      expect(player.total_score).to eq(0)
    end

    it 'returns 0 when all frames have nil pins knocked down by first throw' do
      create(:frame, player: player, pins_knocked_down_by_first_throw: nil)
      expect(player.total_score).to eq(0)
    end

    it 'returns sum of total scores of frames with status open or completed' do
      player.frames << create_list(:frame, 1, player: player, status: :open)
      player.frames << create_list(:frame, 9, player: player, status: :completed)

      total_frames = player.frames.filter_by_status(['open', 'completed']).count
      player.frames.update_all(pins_knocked_down_by_first_throw: 3, pins_knocked_down_by_second_throw: 2)
      # Stub total_score method of frames to return 5 for each completed frame
      allow_any_instance_of(Frame).to receive(:total_score).and_return(5)

      total_score = total_frames * 5
      expect(player.total_score).to eq(total_score)
    end

    it 'skips frames where pins knocked down by first throw is nil' do
      player.frames << create(:frame, player: player, pins_knocked_down_by_first_throw: nil)
      player.frames << create(:frame, player: player, pins_knocked_down_by_first_throw: 5)

      # Stub total_score method of frames to return 5 for each frame
      allow_any_instance_of(Frame).to receive(:total_score).and_return(5)

      expect(player.total_score).to eq(5)
    end
  end
end
