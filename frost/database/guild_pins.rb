# frozen_string_literal: true

module Frost
  # Represents a pins DB.
  class Pins
    # Easy way to access the DB.
    @@pg = POSTGRES[:archiver_settings]

    # Sets up an existing archive channel.
    def self.setup(data)
      POSTGRES.transaction do
        @@pg.insert_conflict(target: :guild_id, update: { channel_id: data.options["channel"] }).insert(guild_id: data.server.id, channel_id: data.options["channel"], setup_at: Time.now.to_i, setup_by: data.user.id)
      end
    end

    # Gets the existing archive channel.
    def self.channel(data)
      POSTGRES.transaction do
        data.bot.channel(@@pg.where(guild_id: data.server.id).get(:channel_id))
      end
    end

    # Removes all instances of this channel.
    def self.remove(data)
      POSTGRES.transaction do
        @@pg.where(channel_id: data.id, guild_id: data.server.id).delete
      end
    end

    # Gets an existing archive channel.
    def self.get(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id).get(:channel_id)
      end
    end

    # Deletes an existing archive channel.
    def self.disable(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id).delete
      end
    end

    # Get a settings display view.
    def self.view(data)
      POSTGRES.transaction do
        @@pg.where(guild_id: data.server.id).first
      end
    end
  end
end
