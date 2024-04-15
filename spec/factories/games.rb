# FactoryBot definition for generating game objects
FactoryBot.define do
  factory :game do
    no_of_players { rand(1..5) }  # Randomly generate number of players between 1 and 5
    status { 0 }  # Default status for the game (0: initiated)
  end
end
