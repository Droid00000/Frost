# frozen_string_literal: true

module Moderation
  # Cached resources for RoboMod.
  class Cache
    # @return [Sequel::Dataset]
    GUILDS = BOT.db[:robomod_settings]

    # @return [Hash<Integer => Array<Array<Integer>>>]
    attr_reader :modals

    # SQL query to update an existing guild or insert a new one.
    GUILD_UPSERT = <<~QUERY
      MERGE INTO robomod_settings main USING (VALUES (?, ?, ?, ?, ?, ?, ?)) AS
        params (guild_id, setup_at, timeout_seconds, channel_id, setup_by, exempt_roles, exempt_channels)
          ON main.guild_id = params.guild_id
      WHEN MATCHED THEN
        UPDATE SET
          channel_id = COALESCE(params.channel_id, main.channel_id),
          exempt_roles = COALESCE(params.exempt_roles, main.exempt_roles),
          exempt_channels = COALESCE(params.exempt_channels, main.exempt_channels),
          timeout_seconds = COALESCE(params.timeout_seconds, main.timeout_seconds)
      WHEN NOT MATCHED THEN
        INSERT (guild_id, setup_at, setup_by, channel_id, exempt_roles, exempt_channels, timeout_seconds)
        VALUES (
          params.guild_id,
          params.setup_at,
          params.setup_by,
          params.channel_id,
          params.exempt_roles,
          params.exempt_channels,
          params.timeout_seconds
        )
        RETURNING main.*;
    QUERY

    # Fetch all of the data for RoboMod from the DB.
    # This method must be called before the bot connects to
    # Discord. Make sure to turn off any other bot containers.
    def initialize
      @guilds = {}
      @modals = {}
      @locker = Frost::Locker.new

      GUILDS.order(Sequel.asc(:guild_id))
            .paged_each { @guilds[it[:guild_id]] = Guild.new(it) }
    end

    # Fetch a single guild.
    # @param guild_id [Integer, Guild] The ID of the guild to fetch.
    # @return [Moderation::Guild, nil] The guild for the given guild ID.
    def fetch_guild(guild_id)
      @guilds[guild_id.resolve_id]
    end

    # Delete a single guild.
    # @param guild_id [Integer, Guild] The ID of the guild to delete.
    # @return [Moderation::Guild, nil] The guild for the given guild ID.
    def delete_guild(guild_id)
      guild_id = guild_id.resolve_id

      @locker.synchronize(guild_id) do
        result = GUILDS.where(guild_id:).returning(:guild_id)

        @guilds.delete(guild_id) if result.delete[0]&.[](:guild_id)
      end
    end

    # Update a single guild.
    # @param guild_id [Integer, Guild] The ID of the guild to update.
    # @param rest [Hash] All of the parameters to update for the guild.
    # @return [Hash, nil] The new guild-data, or `nil` if the guild was deleted.
    def update_guild(guild_id, rest)
      guild_id = guild_id.resolve_id

      @locker.synchronize(guild_id) do
        result = GUILDS.where(guild_id:).update(**rest).returning

        @guilds[guild_id]&.update_state(result[0]) if result.any?
      end
    end

    # Create or update a guild.
    # @param id [Integer, Guild] The ID of the guild to create.
    # @param channel [Channel, Integer] The ID of the alert channel for the guild.
    # @param exempt_roles [Array<Integer, Role>] The exempt role IDs for the guild.
    # @param setup_by [User, Member, Integer] The ID of the user configuring the guild.
    # @param exempt_channels [Array<Channel, Role>] The exempt channel IDs for the guild.
    # @param timeout_duration [Integer] The timeout duration (in seconds) for flagged members.
    # @return [Moderation::Guild] The guild that was created (or updated if an upsert occured).
    def create_guild(
      id:, exempt_roles:, setup_by:,
      channel:, exempt_channels:, timeout_duration:
    )
      guild_id = id.resolve_id

      list = [
        guild_id,
        Time.now.to_i,
        timeout_duration,
        channel.resolve_id,
        setup_by.resolve_id,
        exempt_roles&.map(&:resolve_id),
        exempt_channels&.map(&:resolve_id)
      ]

      @locker.synchronize(guild_id) do
        result = BOT.db.run(GUILD_UPSERT, *list).first

        if (cached_guild = @guilds[guild_id])
          cached_guild.tap { it.update_state(result) }
        else
          @guilds[result[:guild_id]] = Guild.new(result)
        end
      end
    end
  end
end
