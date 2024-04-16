class Frame < ApplicationRecord
  # Associations
  belongs_to :game
  belongs_to :player

  # Status enum for frames
  enum status: { pending: 0, open: 1, completed: 2 }

  # Scope to filter frames by status
  scope :filter_by_status, ->(status) { where(status: status) }

  # Callbacks
  before_update :set_strike, :set_spare, :set_bonus_throw_pins, :update_frame_status
  after_update :update_game_status, if: -> { frame_number == 10 && completed? }

  # Calculates the total score for the frame
  def total_score
    return 0 if pins_knocked_down_by_first_throw.nil?

    score = pins_knocked_down_by_first_throw
    score += pins_knocked_down_by_second_throw unless pins_knocked_down_by_second_throw.nil?
    score += bonus_throw_pins unless bonus_throw_pins.nil?

    score
  end

  private

  # Sets the strike flag if all pins are knocked down in the first throw
  def set_strike
    return if pins_knocked_down_by_first_throw.to_i != 10

    self.strike = true
  end

  # Sets the spare flag if the sum of pins knocked down in two throws equals 10
  def set_spare
    return if strike || (pins_knocked_down_by_first_throw.to_i + pins_knocked_down_by_second_throw.to_i != 10)

    self.spare = true
  end

  # Sets bonus throw pins for the previous frame if applicable
  def set_bonus_throw_pins
    prev_frame = last_frame(frame_number - 1)
    return if prev_frame.nil?

    bonus_point = 0
    if prev_frame.strike
      bonus_point += self.pins_knocked_down_by_first_throw.to_i + self.pins_knocked_down_by_second_throw.to_i
      # If Player hits last two stroke to strike, So update bonus_pin_point for previous of prev_frame
      check_prev_of_prev_frame(prev_frame.frame_number) if self.pins_knocked_down_by_second_throw.nil?
    elsif prev_frame.spare
      bonus_point += self.pins_knocked_down_by_first_throw.to_i
    else
      return
    end

    prev_frame.update_columns(bonus_throw_pins: bonus_point)
  end

  # Retrieves the previous frame
  def last_frame(frame_no)
    return nil if frame_no == 0

    Frame.find_by(game_id: game_id, player_id: player_id, frame_number: frame_no)
  end

  # - Updates the bonus_throw_pins of the previous-previous frame if conditions are met.
  def check_prev_of_prev_frame(prev_frame_number)
    prev_prev_frame = last_frame(prev_frame_number - 1)
    return if prev_prev_frame.nil? || !prev_prev_frame.strike

    bonus_point = prev_prev_frame.bonus_throw_pins.to_i + self.pins_knocked_down_by_first_throw.to_i
    prev_prev_frame.update_columns(bonus_throw_pins: bonus_point)
  end

  # Updates the status of the frame
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

  # Checks if the frame can be closed
  def can_closed?
    return false if frame_number == 10 && bonus_throw_pins.nil?

    strike || spare || (frame_number != 10 && pins_knocked_down_by_second_throw.present?) || (frame_number == 10 && bonus_throw_pins.present?)
  end

  # Updates the game status to completed after the last frame
  def update_game_status
    game.update_game_status(2)
  end
end
