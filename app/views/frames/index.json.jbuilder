# Render a JSON array containing representations of @frames using a partial template named '_frame.json.jbuilder'.
json.array! @frames, partial: "frames/frame", as: :frame
