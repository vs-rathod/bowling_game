# FrameValidator: Model/Database Level Validation
module FrameValidator
  extend ActiveSupport::Concern

  included do

    # Validates
    validate :frame_status_must_be_open, :pins_knocked_down_by_first_throw_within_range, on: :update
    validate :pins_knocked_down_by_second_throw_within_range, :bonus_throw_pins_within_range, on: :update

    private

    # Validates that the status should open while changing 2nd and third throw
    def frame_status_must_be_open
      return if pins_knocked_down_by_first_throw_changed? || open? || !changes.keys.include?('pins_knocked_down_by_second_throw') || changes.keys.include?('status')

      errors.add(:status, "Frame status is #{status}: This operation is not allowed.")
      raise_record_invalid_error
    end

    # Validates that the pins_knocked_down_by_first_throw attribute is within the range of 0 to 10.
    def pins_knocked_down_by_first_throw_within_range
      return if pins_knocked_down_by_first_throw.nil? || (0..10).include?(pins_knocked_down_by_first_throw)

      errors.add(:pins_knocked_down_by_first_throw, "value must be between 0 to 10")
      raise_record_invalid_error

    end

    # Validates that the pins_knocked_down_by_first_throw + pins_knocked_down_by_second_throw  attribute is within the range of 0 to 10.
    def pins_knocked_down_by_second_throw_within_range
      return if pins_knocked_down_by_first_throw.nil? || pins_knocked_down_by_second_throw.nil? || frame_number == 10

      remaing_pins = 10 - pins_knocked_down_by_first_throw

      return if (0..remaing_pins).include?(pins_knocked_down_by_second_throw)

      errors.add(:pins_knocked_down_by_second_throw, "value must be between 0 to #{remaing_pins}")
      raise_record_invalid_error
    end

    # Validates that the bonus_throw_pins attribute is within the range of 0 to 10.
    def bonus_throw_pins_within_range
      return if bonus_throw_pins.nil? || frame_number != 10 || (0..10).include?(bonus_throw_pins)

      errors.add(:bonus_throw_pins, "value must be between 0 to 10")
      raise_record_invalid_error
    end

    def raise_record_invalid_error
      raise ActiveRecord::RecordInvalid.new(self)
    end
  end
end
