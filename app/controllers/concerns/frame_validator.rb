module FrameValidator
  extend ActiveSupport::Concern

  included do

    private

    def validate_params
      validate_player
      validate_throw
      validate_frame
    end

    def validate_player
      player_id = params[:player_id]
      raise ActionController::BadRequest, "Player ID must be present" if player_id.blank?

      player = Player.find_by(id: player_id)
      raise ActiveRecord::RecordNotFound if player.blank?

      raise ActionController::BadRequest, "FrameID and PlayerID are not matching, Please Check!" if @frame.player_id != player.id
    end

    def validate_throw
      throw_value = params[:throw]
      raise ActionController::BadRequest, "throw must be present" if throw_value.blank?
      raise ActionController::BadRequest, "throw value must be Integer" unless throw_value.is_a?(Integer)
      raise ActionController::BadRequest, "throw value must be between 1 to 3" unless (1..3).include?(throw_value)

      if throw_value == 1
        validate_first_throw_params
      elsif throw_value == 2
        validate_second_throw_params
      else
        validate_bonus_throw_params
      end
    end

    def validate_first_throw_params
      raise ActionController::BadRequest, "pins_knocked_down_by_first_throw must be present" if params[:pins_knocked_down_by_first_throw].nil?
      raise ActionController::BadRequest, "pins_knocked_down_by_first_throw value must be between 0 to 10" unless (0..10).include?(params[:pins_knocked_down_by_first_throw])
      raise ActionController::BadRequest, "pins_knocked_down_by_second_throw should not be present" if params[:pins_knocked_down_by_second_throw].present?
      raise ActionController::BadRequest, "bonus_throw_pins should not be present" if params[:bonus_throw_pins].present?
    end

    def validate_second_throw_params
      raise ActionController::BadRequest, "pins_knocked_down_by_second_throw must be present" if params[:pins_knocked_down_by_second_throw].nil?
      raise ActionController::BadRequest, "pins_knocked_down_by_second_throw value must be between 0 to 10" unless (0..10).include?(params[:pins_knocked_down_by_second_throw])
      raise ActionController::BadRequest, "pins_knocked_down_by_first_throw should not be present" if params[:pins_knocked_down_by_first_throw].present?
      raise ActionController::BadRequest, "bonus_throw_pins should not be present" if params[:bonus_throw_pins].present?
    end

    def validate_bonus_throw_params
      raise ActionController::BadRequest, "bonus_throw_pins must be present" if params[:bonus_throw_pins].nil?
      raise ActionController::BadRequest, "bonus_throw_pins value must be between 0 to 10" unless (0..10).include?(params[:bonus_throw_pins])
      raise ActionController::BadRequest, "pins_knocked_down_by_first_throw should not be present" if params[:pins_knocked_down_by_first_throw].present?
      raise ActionController::BadRequest, "pins_knocked_down_by_second_throw should not be present" if params[:pins_knocked_down_by_second_throw].present?
    end

    def validate_frame
      return if params[:throw].blank?

      if params[:throw] == 1
        validate_first_throw_frame
      elsif params[:throw] == 2
        validate_second_throw_frame
      elsif params[:throw] == 3
        validate_bonus_throw_frame
      end
    end

    def validate_first_throw_frame
      raise ActionController::BadRequest, "pins_knocked_down_by_first_throw is already present" unless @frame.pins_knocked_down_by_first_throw.nil?
      validate_previous_frame if @frame.frame_number != 1
    end

    def validate_second_throw_frame
      raise ActionController::BadRequest, "pins_knocked_down_by_second_throw is already present" unless @frame.pins_knocked_down_by_second_throw.nil?
      raise ActionController::BadRequest, "frame status is #{@frame.status}: So this operation is not allowed" unless @frame.open?
      return if @frame.frame_number == 10

      remaining_pins = 10 - @frame.pins_knocked_down_by_first_throw
      raise ActionController::BadRequest, "pins_knocked_down_by_second_throw value must be between 0 to #{remaining_pins}" unless (0..remaining_pins).include?(params[:pins_knocked_down_by_second_throw])
    end

    def validate_bonus_throw_frame
      raise ActionController::BadRequest, "bonus_throw_pins is already present" unless @frame.bonus_throw_pins.nil?
      raise ActionController::BadRequest, "frame status is #{@frame.status}: So this operation is not allowed" unless @frame.open?
    end

    def validate_previous_frame
      prev_frame_number = @frame.frame_number - 1
      prev_frames = @game.frames.where(player_id: @frame.player_id, frame_number: prev_frame_number)&.first
      raise ActionController::BadRequest, "Previous Frames are not completed yet" unless prev_frames.completed?
    end
  end
end
