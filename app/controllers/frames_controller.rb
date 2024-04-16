class FramesController < ApplicationController
  # FrameValidator used to validate all bad_request conditions
  include FramesValidator

  before_action :set_game
  before_action :set_frame
  before_action :validate_params

  # PATCH/ /frames/1
  # Updates a frame with the specified throw information.
  def update
    if @frame.update(frame_params)
      render :show, status: :ok
    else
      render json: @frame.errors, status: :unprocessable_entity
    end
  end

  private

  # Sets @game instance variable with the game corresponding to the provided game_id.
  def set_game
    @game = Game.find(params[:game_id])
  end

  # Sets @frame instance variable with the frame corresponding to the provided ID within the game.
  def set_frame
    @frame = @game.frames.find(params[:id])
  end

  # Defines permitted parameters for frame update based on the throw number.
  def frame_params
    params.require(:frame).permit(permitted_attribute_for_update)
  end

  # Determines permitted attributes for frame update based on the throw number.
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
