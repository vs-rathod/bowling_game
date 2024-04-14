class CreateTablesForBowlingGameDatabase < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.integer :no_of_players
      t.integer :status, default: 0

      t.timestamps
    end

    create_table :players do |t|
      t.string :name

      t.timestamps
    end

    create_table :frames do |t|
      t.integer :frame_number
      t.integer :status, default: 0
      t.integer :pins_knocked_down_by_first_throw
      t.integer :pins_knocked_down_by_second_throw
      t.boolean :strike, default: false
      t.boolean :spare, default: false
      t.integer :bonus_throw_pins

      t.belongs_to :game, index: true, null: false, foreign_key: true
      t.belongs_to :player, null: false, foreign_key: true

      t.timestamps
    end
  end
end
