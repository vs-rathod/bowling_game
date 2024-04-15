class GamesController < ApplicationController
  before_action :set_game, only: :show
  before_action :validate_game_params, only: :create

  # GET /games
  # Retrieves a list of all games.
  def index
    @games = Game.all
  end

  # GET /games/1
  # Displays details of a current game.
  def show; end

  # POST /games
  # Creates a new game instance with specified parameters.
  def create
    @game = Game.new(game_params)

    if @game.save
      # After successful game creation, initiate background job to build game dependencies.
      GameDependenciesBuildJob.perform_now(game_id: @game.id, player_names: params[:player_names])
      render :show, status: :created
    else
      render json: @game.errors, status: :unprocessable_entity
    end
  end

  private

  # Sets @game instance variable with the game corresponding to the provided ID.
  def set_game
    @game = Game.find(params[:id])
  end

  # Validates game creation parameters to ensure data integrity.
  def validate_game_params
    raise ActionController::BadRequest, "no_of_players must be present" if params[:no_of_players].blank?

    raise ActionController::BadRequest, "no_of_players value must be Integer" unless params[:no_of_players].class == Integer

    raise ActionController::BadRequest, "no_of_players value must be between 1 to 5" unless params[:no_of_players] > 0 && params[:no_of_players] < 6

    return if params[:player_names].class == Array && params[:player_names]&.uniq&.count == params[:no_of_players]

    raise ActionController::BadRequest, "player_names must be present" if params[:player_names].blank?

    raise ActionController::BadRequest, "required [] of player_names " unless params[:player_names].class == Array

    raise ActionController::BadRequest, "no_of_players value and count of player_names should be same"
  end

  # Defines permitted parameters for game creation.
  def game_params
    params.require(:game).permit(:no_of_players)
  end
end
