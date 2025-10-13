# frozen_string_literal: true

module Moderation
  # Represents a moderation DB.
  class Storage
    # Easy way to access incidents.
    @@incidents = []

    # Easy way to access the DB.
    @@pg = POSTGRES[:guild_incidents]

    # Insert a set of new incidents into the DB.
    def self.drain
      return if @@incidents.empty?

      POSTGRES.transaction { @@incidents.clear if @@pg.multi_insert(@@incidents) }
    end

    # Add an incdient to the local cache.
    def self.add(incident)
      @@incidents << incident
    end
  end
end
