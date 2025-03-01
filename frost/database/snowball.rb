# frozen_string_literal: true

module Frost
  # Represents a snowball DB.
  class Snow
    # Easy way to access the DB.
    @@pg = POSTGRES[:snowball_players]

    # Gets the snowballs a user has.
    def self.snowballs(data)
      POSTGRES.transaction do
        @@pg.where(user_id: data.user.id).get(:balance)
      end
    end

    # Adds a user to the DB.
    def self.user(data)
      POSTGRES.transaction do
        @@pg.insert_conflict.insert(user_id: data.user.id)
      end
    end

    # Checks if a user has a snowball.
    def self.snowball?(data, hash = false)
      POSTGRES.transaction do
        if hash
          @@pg.where(user_id: data.options["member"]).get(:balance)
        elsif @@pg.where(user_id: data.user.id).get(:balance)
          @@pg.where(user_id: data.user.id).get(:balance) >= 1
        else
          false
        end
      end
    end

    # Adds or removes a snowball.
    def self.balance(data, add = false)
      POSTGRES.transaction do
        if add
          @@pg.where(user_id: data.user.id).update(balance: Sequel[:balance] + 1)
        else
          @@pg.where(user_id: data.user.id).update(balance: Sequel[:balance] - 1)
        end
      end
    end

    # Steals snowballs.
    def self.steal(data)
      POSTGRES.transaction do
        @@pg.where(user_id: data.user.id).update(balance: Sequel[:balance] + data.options["amount"])
        @@pg.where(user_id: data.options["member"]).update(balance: Sequel[:balance] - data.options["amount"])
      end
    end
  end
end
