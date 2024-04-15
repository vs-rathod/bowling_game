# Extract specific attributes from the frame object and output them in JSON format.
json.extract! frame, :id, :frame_number, :status, :pins_knocked_down_by_first_throw, :pins_knocked_down_by_second_throw, :strike, :spare, :bonus_throw_pins

# Output the total score for the frame.
json.total_score frame.total_score
# Output the name of the player associated with the frame, if present.
json.player_name frame&.player&.name
