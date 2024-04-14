json.id game.id
json.no_of_players game.no_of_players
json.status game.status

json.results game.players do |player|
  json.player_id player.id
  json.player_name player.name
  json.total_score player.total_score

  json.frames player.frames.order(created_at: :asc) do |frame|
    json.id frame.id
    json.frame_number frame.frame_number
    json.status frame.status
    json.pins_knocked_down_by_first_throw frame.pins_knocked_down_by_first_throw
    json.pins_knocked_down_by_second_throw frame.pins_knocked_down_by_second_throw
    json.strike frame.strike
    json.spare frame.spare
    json.bonus_throw_pins frame.bonus_throw_pins
    json.total_frame_score frame.total_score
  end
end
