# Render JSON representation of the @game object using a partial template named '_game.json.jbuilder'.
json.partial! "games/game", game: @game
