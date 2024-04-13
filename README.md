# README

<!-- This README would normally document whatever steps are necessary to get the
application up and running. -->

Things you may want to cover:

* Project Setup
  * Ruby =>         ruby 3.0.4p208 (2022-04-12 revision 3fa771dded) [arm64-darwin21]
  * Rails =>        Rails 7.1.3.2
  * PostgreSQL =>   psql (PostgreSQL) 16.2

* Application dependencies
    * rails secret (cmd) <!-- command for generating secret_key_base and                                 add into development environment -->
        * EDITOR=vim rails credentials:edit --environment=development
          * OR
        * source .env

* Configuration

* Database creation & initialization
    * add credentails for database.yml file through .env or .zshrc or bash_profile
    * setup database for development env
        * rails db:create


* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
