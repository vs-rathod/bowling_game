class CreateTablesForBowlingGameDatabase < ActiveRecord::Migration[7.1]
  def change
    # Creates a table to store information about each game.
    create_table :games do |t|
      t.integer :no_of_players  # Number of players in the game.
      t.integer :status, default: 0  # Status of the game (0: initiated, 1: live, 2: completed).

      t.timestamps  # Automatically created columns for recording creation and update timestamps.
    end

    # Creates a table to store information about each player.
    create_table :players do |t|
      t.string :name  # Name of the player.

      t.timestamps  # Automatically created columns for recording creation and update timestamps.
    end

    # Creates a table to store information about each frame in a game.
    create_table :frames do |t|
      t.integer :frame_number  # Number of the frame.
      t.integer :status, default: 0  # Status of the frame (0: pending, 1: open, 2: completed).
      t.integer :pins_knocked_down_by_first_throw  # Number of pins knocked down by the first throw.
      t.integer :pins_knocked_down_by_second_throw  # Number of pins knocked down by the second throw.
      t.boolean :strike, default: false  # Indicates if the frame resulted in a strike.
      t.boolean :spare, default: false  # Indicates if the frame resulted in a spare.
      t.integer :bonus_throw_pins  # Number of bonus pins awarded for the frame.

      t.belongs_to :game, index: true, null: false, foreign_key: true  # Foreign key reference to the games table.
      t.belongs_to :player, null: false, foreign_key: true  # Foreign key reference to the players table.

      t.timestamps  # Automatically created columns for recording creation and update timestamps.
    end
  end
end
