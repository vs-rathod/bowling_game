class Frame < ApplicationRecord
  belongs_to :game
  belongs_to :player

  enum :status, { pending: 0, open: 1, completed: 2 }

  scope :filter_by_status, ->(status) { where(status: status) }

  before_update :set_strike, :set_spare, :set_bonus_throw_pins, :update_frame_status
  after_update :update_game_status, if: -> { frame_number == 10 && completed? }

  def total_score
    return 0 if pins_knocked_down_by_first_throw.nil?

    score = pins_knocked_down_by_first_throw
    score += pins_knocked_down_by_second_throw unless pins_knocked_down_by_second_throw.nil?
    score += bonus_throw_pins unless bonus_throw_pins.nil?

    score
  end

  private

  def set_strike
    return if pins_knocked_down_by_first_throw.to_i != 10

    self.strike = true
  end

  def set_spare
    return if strike || (pins_knocked_down_by_first_throw.to_i + pins_knocked_down_by_second_throw.to_i != 10)

    self.spare = true
  end

  def set_bonus_throw_pins
    prev_frame = last_frame
    return if prev_frame.nil?

    bonus_point = 0
    if prev_frame.strike
      bonus_point += self.pins_knocked_down_by_first_throw.to_i + self.pins_knocked_down_by_second_throw.to_i
    elsif prev_frame.spare
      bonus_point += self.pins_knocked_down_by_first_throw.to_i
    else
      return
    end

    prev_frame.update_columns(bonus_throw_pins: bonus_point)
  end

  def last_frame
    return nil if frame_number == 1

    Frame.find_by(game_id: game_id, player_id: player_id, frame_number: frame_number - 1)
  end

  def update_frame_status
    return if completed?

    new_status = status
    if can_closed?
      new_status = 2
    elsif pins_knocked_down_by_second_throw.nil?
      new_status = 1
    end
    self.status = new_status
  end

  def can_closed?
    return false if frame_number == 10 && bonus_throw_pins.nil?

    strike || spare || (frame_number != 10 && pins_knocked_down_by_second_throw.present? ) || (frame_number == 10 && bonus_throw_pins.present? )
  end

  def update_game_status
    game.update_game_status(2)
  end
end
