class GameController < ApplicationController
  def index
    @current_player = 'X'
    @game_board = ['', '', '', '', '', '', '', '', '']
  end

  def make_move
    index = params[:index].to_i
    @game_board = params[:board]
    @current_player = params[:current_player]
    if @game_board[index] == '' && !check_winner
      @game_board[index] = @current_player
      @current_player = @current_player == 'X' ? 'O' : 'X'
    end

    render json: { current_player: @current_player, game_board: @game_board, winner: check_winner }
  end

  def reset_game
    @current_player = 'X'
    @game_board = ['', '', '', '', '', '', '', '', '']

    render json: { current_player: @current_player, game_board: @game_board, winner: nil }
  end

  private

  def initialize_game_board
    @game_board = ['', '', '', '', '', '', '', '', '']
  end

  def check_winner
    winning_combos = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8], # rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], # columns
      [0, 4, 8], [2, 4, 6]              # diagonals
    ]

    winning_combos.each do |combo|
      a, b, c = combo
      if @game_board[a].present? && @game_board[a] == @game_board[b] && @game_board[a] == @game_board[c]
        return @game_board[a]
      end
    end

    nil
  end
end
