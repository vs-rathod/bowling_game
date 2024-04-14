# README

<!-- This README would normally document whatever steps are necessary to get the
application up and running. -->

Things you may want to cover:

* Project Setup
  * Ruby =>         ruby 3.0.4p208 (2022-04-12 revision 3fa771dded) [arm64-darwin21]
  * Rails =>        Rails 7.1.3.2
  * PostgreSQL =>   psql (PostgreSQL) 16.2

* Application dependencies
    * source .env

* Configuration

* Database creation & initialization
    * add credentails for database.yml file through .env or .zshrc or bash_profile
    * setup database for development env
        * rails db:create
        * raile db:migrate


* How to run the test suite
  * Rspec tool used for testing, Use below cmd to run rspec test suites
    * bundle exec rspec <!-- Run all test cases. -->
    * bundle exec rspec spec/requests/games_spec.rb <!-- Run all test cases for single file. -->

    * check code coverage using below cmd
      * open coverage/index.html

* ...
# Requirement
  * Imagine that a bowling house will use this API. On the screen, the user starts the game. Then, after each throw, the machine counts how many pins were dropped and calls the API to send this information. In the meantime, the screen is constant.(For example: every 2 seconds) querying the API for the game score and displaying it. Be tolerant of application restarts.

# API flow
  <!-- − Start a new bowling game. -->
  * Create Game using GamesController Post API
   * Client should provide { no_of_players, player_names } as a Request paramteres
   * Once Game is created it will perform GameDependenciesBuildJob
      * Players will be created according to given names in player_names request params
      * using this job 10 frames will be created for each player

  <!-- − Input the number of pins knocked down by each ball. -->
  * Frame can be update after each throw using FramesController#update API
    * FrameValidator used to validate required params to update Frame
        * { player_id, throw, pins_knocked_down_by_first_throw pins_knocked_down_by_second_throw bonus_throw_pins } params used for each request,
        * Request parameters decision will be taken based on the throw number.

  <!-- Output the current game score (which consists of the score for each frame and total score). -->
  * Game Show API
    * To get information about current score of all the players in the current game.
            
