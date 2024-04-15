class Player < ApplicationRecord
  # Association with frames
  has_many :frames

  # Calculates the total score of the player across all frames.
  def total_score
    score = 0
    # Iterate through frames with status 'open' or 'completed' to calculate total score.
    frames.filter_by_status(['open', 'completed']).each do |frame|
      # Skip frames where pins knocked down by the first throw is nil.
      next if frame.pins_knocked_down_by_first_throw.nil?

      # Add the score of the current frame to the total score.
      score += frame.total_score
    end
    score
  end
end
