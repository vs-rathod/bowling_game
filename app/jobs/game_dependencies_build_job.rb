class GameDependenciesBuildJob < ApplicationJob
  # Initializes the GameDependenciesBuildJob with the provided game_id and player_names.
  def initialize(game_id:, player_names:)
    Rails.logger.info "---# Game:[ID:#{game_id}] Performing GameDependenciesBuildJob #---"
    @game = Game.find(game_id)
    @player_names = player_names.uniq

    super()
  end

  # Performs the necessary tasks to build dependencies for the game.
  def perform
    create_dependent_records
    @game.update_game_status(1)
    Rails.logger.info "---# Game:[ID:#{@game.id}] Performed GameDependenciesBuildJob #---"
  end

  private

  # Creates dependent records such as players and their frames for the game.
  def create_dependent_records
    @player_names.each do |name|
      create_player(name)
    end
  end

  # Creates a player with the provided name and builds frames for the player.
  def create_player(name)
    player = Player.create(name: name)
    build_player_frames(player)
    player.save!
  end

  # Builds frames for the provided player.
  def build_player_frames(player)
    (1..10).each do |frame_no|
      player.frames.build(frame_number: frame_no, game_id: @game.id)
    end
  end
end
