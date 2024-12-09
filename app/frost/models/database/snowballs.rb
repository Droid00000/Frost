# frozen_string_literal: true

module Frost
  # Represents an snowballs DB.
  class Snowballs
    # Easy way to access the DB.
    attr_accessor :PG

    # @param database [Sequel::Dataset]
    def initialize(database)
      @@PG = POSTGRES[:snowball_players]
    end

    # Checks if a user is in the Database.
    def self.user?(data)
      POSTGRES.transaction do
        !@@PG.where(user_id: data.user.id).get(:user_id).nil?
      end
    end

    # Checks if a user has a snowball.
    def self.snowball?(data)
      POSTGRES.transaction do
        @@PG.where(user_id: data.user.id).get(:balance) >= 1
      end
    end

    # Gets the snowballs a user has.
    def self.snowballs(data)
      POSTGRES.transaction do
        @@PG.where(user_id: data.user.id).get(:balance)
      end
    end

    # Adds a user to the DB.
    def self.user(data)
      POSTGRES.transaction do
        @@PG.insert(user_id: data.user.id)
      end
    end

    # Adds or removes a snowball.
    def self.balance(data, add: false)
      POSTGRES.transaction do
        if add
          @@PG.where(user_id: data.user.id).update(balance: Sequel[:balance] + balance)
        else
          @@PG.where(user_id: data.user.id).update(balance: Sequel[:balance] - balance)
        end
      end
    end
  end
end
