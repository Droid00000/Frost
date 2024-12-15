# frozen_string_literal: true

module Frost
  # Represents a snowball DB.
  class Snow
    # Easy way to access the DB.
    attr_accessor :PG

    # @param database [Sequel::Dataset]
    def initialize
      @@PG = PG[:snowball_players]
    end

    # Checks if a user is in the Database.
    def self.user?(data)
      PG.transaction do
        !@@PG.where(user_id: data.user.id).get(:user_id).nil?
      end
    end

    # Checks if a user has a snowball.
    def self.snowball?(data, other: false)
      PG.transaction do
        if other
          @@PG.where(user_id: data.options['member']).get(:balance)
        else
          @@PG.where(user_id: data.user.id).get(:balance) >= 1
        end
      end
    end

    # Gets the snowballs a user has.
    def self.snowballs(data)
      PG.transaction do
        @@PG.where(user_id: data.user.id).get(:balance)
      end
    end

    # Adds a user to the DB.
    def self.user(data)
      PG.transaction do
        @@PG.insert(user_id: data.user.id)
      end
    end

    # Steals snowballs.
    def self.steal(data)
      PG.transaction do
        @@PG.where(user_id: data.user.id).update(balance: Sequel[:balance] + data.options['amount'])
        @@PG.where(user_id: data.options['member']).update(balance: Sequel[:balance] - data.options['amount'])
      end
    end

    # Adds or removes a snowball.
    def self.balance(data, add: false)
      PG.transaction do
        if add
          @@PG.where(user_id: data.user.id).update(balance: Sequel[:balance] + 1)
        else
          @@PG.where(user_id: data.user.id).update(balance: Sequel[:balance] - 1)
        end
      end
    end
  end
end
