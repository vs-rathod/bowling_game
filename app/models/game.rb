class Game < ApplicationRecord
  # Association with frames and players
  has_many :frames
  has_many :players, through: :frames, disable_joins: true

  # Enum for game status
  enum status: { initiated: 0, live: 1, completed: 2 }

  # Updates the game status with the provided status.
  def update_game_status(status)
    self.update_columns(status: status)
  end
end
