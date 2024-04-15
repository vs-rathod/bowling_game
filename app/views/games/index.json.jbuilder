# Render a JSON array containing representations of @games using a partial template named '_game.json.jbuilder'.
json.array! @games, partial: "games/game", as: :game
