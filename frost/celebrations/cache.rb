# frozen_string_literal: true

module Celebrations
  # Cached resources for celebrations.
  class Cache
    # @return [Sequel::Dataset]
    GUILDS = BOT.db[:birthday_settings]

    # SQL query to update an existing guild or insert a new one.
    GUILD_UPSERT = <<~QUERY
      MERGE INTO birthday_settings main USING (VALUES (?, ?, ?, ?, ?)) AS
        params (guild_id, setup_at, role_id, channel_id, setup_by) ON main.guild_id = params.guild_id
      WHEN MATCHED THEN
        UPDATE SET
        role_id = COALESCE(params.role_id, main.role_id),
        channel_id = COALESCE(params.channel_id, main.channel_id)
      WHEN NOT MATCHED THEN
        INSERT (guild_id, setup_at, setup_by, role_id, channel_id)
        VALUES (params.guild_id, params.setup_at, params.setup_by, params.role_id, params.channel_id)
        RETURNING main.*;
    QUERY

    # SQL query to fuzzy search timezones matching a specific query.
    SEARCH_TIMEZONES = <<~QUERY
      WITH query_words AS MATERIALIZED(
        SELECT unnest(string_to_array(trim(?), ' ')) AS word
      )
      SELECT entry.name, entry.timezone FROM world_timezones AS entry WHERE EXISTS (
        SELECT 1 FROM query_words WHERE
          entry.search_text % query_words.word OR entry.search_text ILIKE '%' || query_words.word || '%'
        )
      ORDER BY(
        SELECT SUM(
          CASE WHEN match.similarity > 0.2 THEN match.similarity ELSE 0 END +
          CASE WHEN entry.search_text ILIKE '%' || query_words.word || '%' THEN match.similarity ELSE 0 END
        )
      FROM query_words CROSS JOIN
        LATERAL(SELECT similarity(entry.search_text, query_words.word) AS similarity) AS match) DESC LIMIT 25;
    QUERY

    # Fetch all of the data for celebrations from the DB.
    # This method must be called before the bot connects to
    # Discord. Make sure to turn off any other bot containers.
    def initialize
      @guilds = {}
      @locker = Frost::Locker.new

      GUILDS.order(Sequel.asc(:guild_id))
            .paged_each { @guilds[it[:guild_id]] = Guild.new(it) }
    end

    # Fetch a single guild.
    # @param guild_id [Integer, Guild] The ID of the guild to fetch.
    # @return [Celebrations::Guild, nil] The guild for the given guild ID.
    def fetch_guild(guild_id)
      @guilds[guild_id.resolve_id]
    end

    # Delete a single guild.
    # @param guild_id [Integer, Guild] The ID of the guild to delete.
    # @return [Celebrations::Guild, nil] The guild for the given guild ID.
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
        result = GUILDS.where(guild_id:).returning.update(**rest)

        @guilds[guild_id]&.update_state(result[0]) if result.any?
      end
    end

    # Create or update a guild.
    # @param id [Integer, Guild] The ID of the guild to create.
    # @param role [Role, Integer] The ID of the birthday role for the guild.
    # @param setup_by [User, Member, Integer] The ID of the user configuring the guild.
    # @param channel [Integer, Channel] The ID of the birthday annoucement channel for the guild.
    # @return [Celebrations::Guild] The guild that was created (or updated if an upsert occured).
    def create_guild(id:, role:, setup_by:, channel:)
      guild_id = id.resolve_id

      list = [
        guild_id,
        Time.now.to_i,
        role.resolve_id,
        channel.resolve_id,
        setup_by.resolve_id
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
