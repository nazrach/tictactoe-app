# spec/controllers/game_controller_spec.rb
require 'rails_helper'

RSpec.describe GameController, type: :controller do
  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #make_move' do
    context 'with valid parameters' do
      it 'updates the game state' do
        post :make_move, params: { index: 0, board: ['', '', '', '', '', '', '', '', ''], current_player: 'X' }
        json_response = JSON.parse(response.body)
        expect(json_response['current_player']).not_to be_nil
        expect(json_response['game_board']).not_to be_nil
      end
    end

    context 'with an invalid move' do
      it 'does not update the game state' do
        post :make_move, params: { index: 0, board: ['X', '', '', '', '', '', '', '', ''], current_player: 'X' }
        json_response = JSON.parse(response.body)
        expect(json_response['current_player']).not_to be_nil
        expect(json_response['game_board']).not_to be_nil
        expect(json_response['winner']).to be_nil
      end
    end
  end

  describe 'POST #reset_game' do
    it 'resets the game state' do
      post :reset_game
      json_response = JSON.parse(response.body)
      expect(json_response['current_player']).not_to be_nil
      expect(json_response['game_board']).not_to be_nil
      expect(json_response['winner']).to be_nil
    end
  end
end
