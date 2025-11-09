# frozen_string_literal: true

module Boosters
  # A guild that a server booster belongs to.
  class Guild
    # Map of guild flags.
    FLAGS = {
      any_icon: 1 << 0,
      no_gradient: 1 << 1,
      self_service: 1 << 2,
      manual_queue: 1 << 3
    }.freeze

    # @return [Integer] the snowflake ID of the guild.
    attr_reader :id

    # @return [Integer] the snowflake ID of the guild's hoist role.
    attr_reader :role_id

    # @return [Integer] the features flags for this guild as a bitfield.
    attr_reader :features

    # @return [Integer] the UNIX timestamp of when this guild was setup.
    attr_reader :setup_at

    # @return [Integer] the snowflake ID of the user that setup this guild.
    attr_reader :setup_by

    # @return [Sequel::Dataset]
    DB = POSTGRES[:booster_settings]

    # @!visibility private
    def initialize(state)
      update_state(state)
    end

    # Delete the record for this guild.
    def delete
      DB.where(guild_id: @id).delete
    end

    # Check if this guild's role was deleted.
    # @return [Boolean] Whether the role was deleted.
    def role_deleted?
      BOT.server(@id)&.role(@role_id).nil?
    end

    # Get metadata about the settings for this guild.
    # @return [Array(String, Integer)] Metadata info about this guild.
    def view
      [BOT.user(@setup_by)&.name, @setup_at]
    end

    # Update the properties of this guild.
    # @param role_id [Integer] The ID of the hoist role for this guild.
    # @param added_features [Integer] The feature flags to set for this guild.
    # @param unset_features [Integer] The feature flags to remove for this guild.
    def edit(**rest)
      rest = {
        role_id: rest[:role_id],
        features: Sequel.lit("(features | ?) & ~?",
                             rest[:added_features], rest[:unset_features])
      }

      update_state(DB.where(guild_id: @id).returning.update(**rest.compact).first)
    end

    # @!method any_icon?
    #   @return [Boolean] whether guild boosters can use external emojis as role icons.
    # @!method no_graident?
    #   @return [Boolean] whether setting graidents to booster roles has been disabled.
    # @!method self_service?
    #   @return [Boolean] whether this guild is using the self service mode for booster perks.
    # @!method manual_queue?
    #   @return [Boolean] whether this guild is using the manual approval mode for booster perks.
    FLAGS.each do |name, value|
      define_method("#{name}?") do
        @features.anybits?(value)
      end
    end

    # @!visibility private
    def self.create(...)
      Orchestrator.pool.create_guild(...)
    end

    # @!visibility private
    def self.delete(data)
      Orchestrator.pool.delete_guild(guild_id: data.server.id)
    end

    # @!visibility private
    def self.get(data, hit: false)
      Orchestrator.pool.guild(guild_id: data.server.id, hit: hit)
    end

    private

    # @!visibility private
    def update_state(new_data)
      @id = new_data[:guild_id]
      @role_id = new_data[:role_id]
      @features = new_data[:features]
      @setup_by = new_data[:setup_by]
      @setup_at = new_data[:setup_at]
    end
  end

  # Represents a singular booster.
  class Booster
    # @return [Integer] the snowflake user ID of the booster.
    attr_reader :id

    # @return [Boolean] whether or not the booster is banned.
    attr_reader :banned
    alias banned? banned

    # @return [Integer] the snowflake ID of the booster's role.
    attr_reader :role_id

    # @return [Integer] the snowflake ID of the booster's guild.
    attr_reader :guild_id

    # @return [Integer] the RGB hex color of the booster's role.
    attr_reader :role_color

    # @return [Sequel::Dataset]
    DB = POSTGRES[:guild_boosters]

    # @!visibility private
    def initialize(state)
      @banned = false
      update_state(state)
    end

    # Get the audit log reason for this booster.
    # @return [String] The reason for this booster.
    def reason
      @reason ||= "Booster Roles (ID: #{@id})"
    end

    # Check if this booster's role was deleted.
    # @return [Boolean] Whether the role was deleted.
    def role_deleted?
      BOT.server(@guild_id)&.role(@role_id).nil?
    end

    # Get the guild for this booster.
    # @return [Guild] The guild for this booster.
    def guild
      Orchestrator.pool.guild(guild_id:, hit: true)
    end

    # Permanently delete the record for this booster.
    def delete
      DB.where(guild_id: @guild_id, user_id: @id).delete
    end

    # Permanently try to delete the record for this booster.
    def try_delete(...)
      Booster.delete(...) unless role_deleted? == false
    end

    # Update the properties of this booster.
    # @param role_id [Integer, nil] The role to set for this booster.
    # @param role_color [ColourRGB, nil] The role color to set for this booster.
    def edit(**rest)
      me = {
        user_id: @id,
        guild_id: @guild_id
      }

      rest = {
        role_id: rest[:role].resolve_id,
        color_id: (rest[:color_id] || rest[:role]&.color)&.to_i
      }

      update_state(DB.where(**me).returning.update(**rest.compact).first)
    end

    # @!visibility private
    def self.create(...)
      Orchestrator.pool.create_booster(...)
    end

    # @!visibility private
    def self.get(data)
      if (target = data.options["target"])
        Orchestrator.pool.booster(guild_id: data.server.id, user_id: target.to_i)
      else
        Orchestrator.pool.booster(guild_id: data.server.id, user_id: data.user.id)
      end
    end

    # @!visibility private
    def self.delete(data)
      if (target = data.options["target"])
        Orchestrator.pool.delete_booster(guild_id: data.server.id, user_id: target.to_i)
      else
        Orchestrator.pool.delete_booster(guild_id: data.server.id, user_id: data.user.id)
      end
    end

    private

    # @!visibility private
    def update_state(new_data)
      @user_id = new_data[:user_id]
      @role_id = new_data[:role_id]
      @guild_id = new_data[:guild_id]
      @role_color = new_data[:color_id]
    end
  end

  # Represents a banned user.
  class Banned
    # @return [Boolean] if the user has been banned or not.
    attr_reader :banned
    alias banned? banned

    # @return [Integer] the ID of the user this ban is for.
    attr_reader :user_id

    # @return [Integer] the ID of the guild this ban is for.
    attr_reader :guild_id

    # @return [Integer] the UNIX timestamp of when this ban was created.
    attr_reader :banned_at

    # @return [Integer] the ID of the user responsible for creating the ban.
    attr_reader :banned_by

    # @return [Sequel::Dataset]
    DB = POSTGRES[:banned_boosters]

    # @!visibility private
    def initialize(data)
      @banned = true
      @user_id = data[:user_id]
      @guild_id = data[:guild_id]
      @banned_at = data[:banned_at]
      @banned_by = data[:banned_by]
    end

    # Get the guild for this banned user.
    # @return [Guild] The guild for this user.
    def guild
      Layer.pool.guild(guild_id: @guild_id)
    end

    # Remove the ban for this banned user.
    def delete
      DB.where(guild_id: @guild_id, user_id: @user_id).delete
    end

    # @!visibility private
    def self.create(...)
      Orchestrator.pool.create_ban(...)
    end

    # @!visibility private
    def self.delete(...)
      Orchestrator.pool.delete_ban(...)
    end

    # @!visibility private
    def self.get(data)
      if (target = data.options["target"])
        Orchestrator.pool.ban(guild_id: data.server.id, user_id: target.to_i)
      else
        Orchestrator.pool.ban(guild_id: data.server.id, user_id: data.user.id)
      end
    end
  end
end
