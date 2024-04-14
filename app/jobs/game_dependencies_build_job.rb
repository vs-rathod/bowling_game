class GameDependenciesBuildJob < ApplicationJob
  def initialize(game_id:, player_names: [])
    Rails.logger.info "---# Game:[ID:#{game_id}] Performing GameDependenciesBuildJob #---"
    @game = Game.find(game_id)
    @player_names = player_names.uniq

    super()
  end

  def perform
    create_dependent_records
    @game.update_game_status(1)
    Rails.logger.info "---# Game:[ID:#{@game.id}] Performed GameDependenciesBuildJob #---"
  end

  private

  def create_dependent_records
    @player_names.each do |name|
      create_player(name)
    end
  end

  def create_player(name)
    player = Player.create(name: name)
    build_player_frames(player)
    player.save!
  end

  def build_player_frames(player)
    (1..10).each do |frame_no|
      player.frames.build(frame_number: frame_no, game_id: @game.id)
    end
  end
end
