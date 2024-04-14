json.extract! frame, :id, :frame_number, :status, :pins_knocked_down_by_first_throw, :pins_knocked_down_by_second_throw, :strike, :spare, :bonus_throw_pins

json.total_score frame.total_score
json.player_name frame&.player&.name
