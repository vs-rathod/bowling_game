FactoryBot.define do

  factory :game do
    no_of_players { rand(1..5) }
    status { 0 }
  end
end
