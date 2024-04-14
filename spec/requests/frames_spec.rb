require 'rails_helper'

RSpec.describe FramesController, type: :controller do
  let(:game) { create(:game) }
  let(:player) { create(:player) }
  let(:frame) { create(:frame, game: game, player: player) }

  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the frame' do
        patch :update, params: { game_id: game.id, id: frame.id, player_id: player.id, pins_knocked_down_by_first_throw: 5, throw: 1 }, as: :json, format: :json
        frame.reload
        expect(frame.pins_knocked_down_by_first_throw).to eq(5)
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid parameters' do
      it 'renders error response' do
        patch :update, params: { game_id: game.id, id: frame.id, player_id: player.id, pins_knocked_down_by_first_throw: 15, throw: 1 }, as: :json, format: :json
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'private methods' do
    describe '#validate_params' do
      it 'raises bad request if player ID is not present' do
        patch :update, params: { game_id: game.id, id: frame.id }, as: :json, format: :json
        expect(response).to have_http_status(:bad_request)
      end

      it 'raises bad request if player Record Not Found for PlayerID' do
        patch :update, params: { game_id: game.id, id: frame.id, player_id: 0 }, as: :json, format: :json
        expect(response).to have_http_status(:not_found)
      end

      it 'raises bad request if player ID does not match' do
        player_id = Player.where.not(id: frame.player_id).first.id
        patch :update, params: { game_id: game.id, id: frame.id, player_id: player_id }, as: :json, format: :json
        expect(response).to have_http_status(:bad_request)
      end

      it 'raises bad request if throw is not present' do
        patch :update, params: { game_id: game.id, id: frame.id, player_id: player.id }, as: :json, format: :json
        expect(response).to have_http_status(:bad_request)
      end

      it 'raises bad request if throw value is not between 1 and 3' do
        throw_value = rand(4..10)
        patch :update, params: { game_id: game.id, id: frame.id, player_id: player.id, throw: throw_value }, as: :json, format: :json
        expect(response).to have_http_status(:bad_request)
      end

      it 'raises bad request if pins_knocked_down_by_first_throw is already present' do
        pin_value = rand(1..10)
        frame.pins_knocked_down_by_first_throw = 7
        frame.save
        patch :update, params: { game_id: game.id, id: frame.id, player_id: player.id, throw: 1, pins_knocked_down_by_first_throw: pin_value}, as: :json, format: :json
        expect(response).to have_http_status(:bad_request)
      end

      it 'raises bad request if previous frames are not completed yet' do
        pin_value = rand(1..10)
        second_frame = frame.dup
        second_frame.frame_number = 2
        second_frame.save
        patch :update, params: { game_id: game.id, id: second_frame.id, player_id: player.id, throw: 1, pins_knocked_down_by_first_throw: pin_value }, as: :json, format: :json
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
