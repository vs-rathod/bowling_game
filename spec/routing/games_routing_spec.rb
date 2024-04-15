# Require the rails_helper which loads the necessary configurations for testing Rails applications.
require "rails_helper"

# RSpec.describe defines a test suite for the GamesController routing configurations.
RSpec.describe GamesController, type: :routing do
  # Describe block for routing tests
  describe "routing" do
    it "routes to #index" do
      expect(get: "/games").to route_to("games#index")
    end

    it "routes to #show" do
      expect(get: "/games/1").to route_to("games#show", id: "1")
    end


    it "routes to #create" do
      expect(post: "/games").to route_to("games#create")
    end
  end
end
