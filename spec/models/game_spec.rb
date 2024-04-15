require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'associations' do
    it 'has many frames' do
      association = described_class.reflect_on_association(:frames)
      expect(association.macro).to eq(:has_many)
    end

    it 'has many players' do
      association = described_class.reflect_on_association(:players)
      expect(association.macro).to eq(:has_many)
    end
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(initiated: 0, live: 1, completed: 2) }
  end

  describe 'methods' do
    let(:game) { Game.create }

    describe '#update_game_status' do
      it 'updates the game status' do
        game.update_game_status(:completed)
        expect(game.status).to eq('completed')
      end
    end
  end
end
