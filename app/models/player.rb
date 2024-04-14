class Player < ApplicationRecord
  has_many :frames

  def total_score
    score = 0
    frames.filter_by_status(['open', 'completed']).each do |frame|
      next if frame.pins_knocked_down_by_first_throw.nil?

      score += frame.total_score
    end
    score
  end
end
