# frozen_string_literal: true

module Boosters
  # Cached resources for boosters.
  class Cache
    # @return [Sequel::Dataset]
    BANS = BOT.db[:banned_boosters]

    # @return [Sequel::Dataset]
    GUILDS = BOT.db[:booster_settings]

    # @return [Sequel::Dataset]
    BOOSTERS = BOT.db[:guild_boosters]

    # SQL query to update an existing guild or insert a new one.
    GUILD_UPSERT = <<~QUERY
      MERGE INTO booster_settings main USING (VALUES (?, ?, ?, ?, ?)) AS
        params (guild_id, features, setup_at, role_id, setup_by) on main.guild_id = params.guild_id
      WHEN MATCHED THEN
        UPDATE SET role_id = params.role_id, features = params.features
      WHEN NOT MATCHED THEN
        INSERT (guild_id, features, setup_at, role_id, setup_by)
        VALUES (params.guild_id, params.features, params.setup_at, params.role_id, params.setup_by)
        RETURNING main.*;
    QUERY

    # Fetch all of the data for guild boosters from the DB.
    # This method must be called before the bot connects to
    # Discord. Make sure to turn off any other bot containers.
    def initialize
      @guilds = {}
      @locker = Frost::Locker.new

      GUILDS.order(:setup_at, :guild_id)
            .paged_each { @guilds[it[:guild_id]] = Guild.new(it) }

      BOOSTERS.order(:guild_id, :user_id)
              .paged_each { @guilds[it[:guild_id]]&.push_booster(it) }

      BANS.select(:guild_id, :user_id).order(:guild_id)
          .paged_each { @guilds[it[:guild_id]]&.push_ban(it[:user_id]) }
    end

    # Fetch a single guild.
    # @param guild_id [Integer, Guild] The ID of the guild to fetch.
    # @return [Boosters::Guild, nil] The guild for the given guild ID.
    def fetch_guild(guild_id)
      @guilds[guild_id.resolve_id]
    end

    # Delete a single guild.
    # @param guild_id [Integer, Guild] The ID of the guild to delete.
    # @return [Boosters::Guild, nil] The guild for the given guild ID.
    def delete_guild(guild_id)
      guild_id = guild_id.resolve_id

      @locker.synchronize(guild_id) do
        result = GUILDS.where(guild_id:).returning(:guild_id)

        if result.delete.first&.[](:guild_id)
          @guilds.delete(guild_id)&.tap(:set_tombstone_state)
        end
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
    # @param role [Role, Integer] The ID of the hoist role for the guild.
    # @param features [Integer] The features for the guild combined as a bitfield.
    # @param setup_by [User, Member, Integer] The ID of the user configuring the guild.
    # @return [Boosters::Guild] The guild that was created (or updated if an upsert occured).
    def create_guild(id:, role:, features:, setup_by:)
      guild_id = id.resolve_id

      list = [
        guild_id,
        features || 0,
        Time.now.to_i,
        role.resolve_id,
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
