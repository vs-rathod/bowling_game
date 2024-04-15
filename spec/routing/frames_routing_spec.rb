# Require the rails_helper which loads the necessary configurations for testing Rails applications.
require "rails_helper"

# RSpec.describe defines a test suite for the FramesController routing configurations.
RSpec.describe FramesController, type: :routing do
  # Describe block for routing tests
  describe "routing" do
    it "routes to #update via PATCH" do
      expect(patch: "games/1/frames/1").to route_to("frames#update", id: "1", game_id: "1")
    end
  end
end
