require "rails_helper"

RSpec.describe FramesController, type: :routing do
  describe "routing" do
    it "routes to #update via PATCH" do
      expect(patch: "games/1/frames/1").to route_to("frames#update", id: "1", game_id: "1")
    end
  end
end
