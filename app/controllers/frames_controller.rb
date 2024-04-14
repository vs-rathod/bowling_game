class FramesController < ApplicationController
  # FrameValidator used to validate all bad_request conditions
  include FrameValidator

  before_action :set_game
  before_action :set_frame
  before_action :validate_params

  # PATCH/ /frames/1
  def update
    if @frame.update(frame_params)
      render :show, status: :ok
    else
      render json: @frame.errors, status: :unprocessable_entity
    end
  end

  private

  def set_game
    @game = Game.find(params[:game_id])
  end

  def set_frame
    @frame = @game.frames.find(params[:id])
  end

  def frame_params
    params.require(:frame).permit(permitted_attribute_for_update)
  end

  def permitted_attribute_for_update
    case params[:throw]
    when 1
      :pins_knocked_down_by_first_throw
    when 2
      :pins_knocked_down_by_second_throw
    when 3
      :bonus_throw_pins
    end
  end
end
