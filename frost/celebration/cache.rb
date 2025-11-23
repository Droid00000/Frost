# frozen_string_literal: true

module Birthdays
  # The cache-layer for birthdays.
  class Storage
    # @return [Sequel::Dataset]
    GUILDS = POSTGRES[:birthday_settings]

    # @!visibility private
    def initialize
      @guilds = {}

      GUILDS.order(:setup_at, :guild_id).paged_each(strategy: :filter) do |row|
        @guilds[row[:guild_id]] = Guild.new(row)
      end
    end

    # Create the instance for this real-time layer.
    # This does all of the setup needed to get everything going.
    def self.login
      @login ||= new
    end

    # @!visibility private
    def self.method_missing(name, ...)
      login.respond_to?(name) ? login.__send__(name, ...) : super
    end

    # Get a guild from the real-time layer.
    # @param guild_id [Integer] The guild ID of the guild that should be fetched.
    # @param hit [true, false] Whether to fallback to a database lookup if the guild isn't cached.
    # @return [Guild, nil] The guild that was found during the lookup, or `nil` if it doesn't exist.
    def guild(guild_id:, hit: false)
      guild = @guilds[guild_id.resolve_id]

      return guild if guild || hit != true

      guild = GUILDS.where(guild_id: guild_id).first
      @guilds[guild[:guild_id]] = Guild.new(guild) if guild
    end

    # Check if a guild exists at the real-time layer.
    # @param guild_id [Integer] The guild ID of the guild that should be checked.
    # @param hit [true, false] Whether to fallback to a database lookup if the guild isn't cached.
    # @return [true, false] Whether or not the guild has been configured to utilize birthday perks.
    def guild?(...)
      !guild(...).nil?
    end

    # Delete a guild, permanently erasing its settings and users.
    # @param guild_id [Integer] The ID of the guild that should be deleted.
    # @return [Guild, nil] The guild that was deleted, or `nil` if there wasn't one to delete.
    def delete_guild(guild_id:)
      @guilds.delete(guild_id)&.tap(&:delete)
    end

    # Create a guild on the real-time layer.
    # @param role_id [Integer] The ID of the role for the guild.
    # @param guild_id [Integer] The snowflake ID of the guild to create.
    # @param setup_by [Integer] The snowflake ID of the user creating the guild.
    # @param setup_at [Integer] The UNIX timestamp of when the guild was created.
    # @param channel_id [Integer, nil] The ID of the announcement channel for the guild.
    # @return [Integer] The resulting state of the action, and the guild that was actioned on.
    def create_guild(**options)
      if (guild = self.guild(guild_id: options[:guild_id]))
        return 200.tap { guild.edit(**options) }
      end

      options = {
        role_id: options[:role_id],
        guild_id: options[:guild_id],
        setup_by: options[:setup_by],
        setup_at: options[:setup_at],
        channel_id: options[:channel_id]
      }

      # We need a role to make the record here.
      return 400 unless options[:role_id]

      guild = GUILDS.insert_conflict.insert_select(**options)
      201.tap { @guilds[guild[:guild_id]] = Guild.new(guild) } if guild
    end
  end
end
