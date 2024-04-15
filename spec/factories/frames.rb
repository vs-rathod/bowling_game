# FactoryBot definition for generating frame objects
FactoryBot.define do
  factory :frame do
    game
    player
    frame_number { 1 }  # Default frame number
  end
end
