require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  describe 'GET #index' do
    it 'assigns all games as @games' do
      game1 = create(:game)
      game2 = create(:game)

      get :index, format: :json
      assigned_games = assigns(:games)

      expect(assigned_games).to include(game1)
      expect(assigned_games).to include(game2)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested game as @game' do
      game = create(:game)

      get :show, params: { id: game.to_param }, format: :json
      expect(assigns(:game)).to eq(game)
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new game' do
        post :create, params: { no_of_players: 2  , player_names: ['Player 1', 'Player 2'] }, as: :json, format: :json

        expect(response).to have_http_status(:success)
        expect(response.content_type).to include('application/json')
      end

      it 'returns a success response' do
        post :create, params: { no_of_players: 2, player_names: ['Player 1', 'Player 2'] }, as: :json, format: :json
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'returns an Bad Request response if no_of_players is not present' do
        post :create, params: { no_of_players: nil, player_names: ['Player 1', 'Player 2'] }, as: :json, format: :json
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an Bad Request response if no_of_players value is not between 1 and 5' do
        post :create, params: { no_of_players: 6 , player_names: ['Player 1', 'Player 2'] }, as: :json, format: :json
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an Bad Request response if player_names are not present' do
        post :create, params: { no_of_players: 2, player_names: nil }, as: :json, format: :json
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an Bad Request response if player_names value is not an array' do
        post :create, params: { no_of_players: 2, player_names: 'Player 1' }, as: :json, format: :json
        expect(response).to have_http_status(:bad_request)
      end

      it 'returns an Bad Request response if no_of_players value and count of player_names are not same' do
        post :create, params: { no_of_players: 2, player_names: ['Player 1'] }, as: :json, format: :json
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end
