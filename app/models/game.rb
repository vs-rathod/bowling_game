class Game < ApplicationRecord
  has_many :frames
  has_many :players, through: :frames, disable_joins: true

  enum :status, { initiated: 0, live: 1, completed: 2 }

  def update_game_status(status)
    self.update_columns(status: status)
  end
end
