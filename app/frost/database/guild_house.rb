# frozen_string_literal: true

module Frost
  # Represents a houses DB.
  class Houses
    # Easy way to access the DB.
    @@pg = POSTGRES[:house_settings]

    # @param data [Discordrb::Interaction]
    def self.head?(data)
      !@@pg.where(guild_id: data.server.id, user_id: data.user.id).empty?
    end

    # Returns the cult role of a member.
    def self.cult(data)
      data.server.role(@@pg.where(guild_id: data.server.id, user_id: data.user.id).get(:role_id))
    end

    # Adds a head of house to the houses DB..
    def self.add(data)
      @@pg.insert(guild_id: data.server.id, user_id: data.user.id, role_id: data.options["role"])
    end

    # The entrite DB.
    def self.all
      self
    end
  end
end
