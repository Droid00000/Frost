# frozen_string_literal: true

require_relative 'constants'

POSTGRES = Sequel.connect(CONFIG['Postgres']['URL'])

POSTGRES.extension(:connection_validator)

POSTGRES.pool.connection_validation_timeout = -1

POSTGRES.create_table?(:media_tracker) do
  String :name, null: false, unique: true
  String :cover, null: false, unique: true
  String :creator, null: false, unique: true
  String :released, null: false, unique: true
  primary_key %i[name creator]
end

POSTGRES.create_table?(:event_settings) do
  Bigint :role_id, unique: true, null: false
  Bigint :guild_id, unique: false, null: false
  primary_key %i[role_id guild_id]
end

POSTGRES.create_table?(:archiver_settings) do
  Bigint :guild_id, null: false, unique: true
  Bigint :channel_id, null: false, unique: true
  primary_key %i[channel_id guild_id]
end

POSTGRES.create_table?(:booster_settings) do
  Bigint :guild_id, null: false, unique: true
  Bigint :hoist_role, null: false, unique: true
  primary_key %i[hoist_role guild_id]
end

POSTGRES.create_table?(:snowball_players) do
  Bigint :user_id, unique: true, null: false
  Bigint :balance, null: false, default: 0
  primary_key %i[user_id balance]
end

POSTGRES.create_table?(:banned_boosters) do
  Bigint :user_id, null: false
  Bigint :guild_id, null: false
  primary_key %i[guild_id user_id]
end

POSTGRES.create_table?(:server_boosters) do
  Bigint :user_id, null: false
  Bigint :role_id, null: false
  Bigint :guild_id, null: false
  primary_key %i[user_id guild_id]
end

POSTGRES.create_table?(:emoji_tracker) do
  Bigint :balance, default: 1
  Bigint :emoji_id, null: false
  Bigint :guild_id, null: false
  primary_key %i[emoji_id guild_id]
end

def booster_records(server: nil, user: nil, role: nil, type: nil)
  POSTGRES.transaction do
    case type
    when :create
      POSTGRES[:server_boosters].insert(guild_id: server, user_id: user, role_id: role)
    when :delete
      POSTGRES[:server_boosters].where(guild_id: server, user_id: user).delete
    when :get_role
      POSTGRES[:server_boosters].where(guild_id: server, user_id: user).get(:role_id)
    when :delete_role
      POSTGRES[:server_boosters].where(guild_id: server, role_id: role).delete
    when :enabled
      !POSTGRES[:booster_settings].where(guild_id: server).get(:hoist_role).nil?
    when :disable
      POSTGRES[:booster_settings].where(guild_id: server).delete
    when :setup
      POSTGRES[:booster_settings].insert(guild_id: server, hoist_role: role)
    when :check_user
      !POSTGRES[:server_boosters].where(guild_id: server, user_id: user).empty?
    when :hoist_role
      POSTGRES[:booster_settings].where(guild_id: server).get(:hoist_role)
    when :update_hoist_role
      POSTGRES[:booster_settings].where(guild_id: server).update(hoist_role: role)
    when :banned
      !POSTGRES[:banned_boosters].where(guild_id: server, user_id: user).empty?
    when :ban
      POSTGRES[:banned_boosters].insert(guild_id: server, user_id: user)
    when :unban
      POSTGRES[:banned_boosters].where(guild_id: server, user_id: user).delete
    when :get_boosters
      POSTGRES[:server_boosters]
    end
  end
end

module Frost
  # Represents a pins DB.
  class Pins
    # Easy way to access the DB.
    attr_accessor :PG

    # @param database [Sequel::Dataset]
    def initialize(database)
      @@PG = database
    end

    # Updates an existing archive channel.
    def self.update(data)
      @@PG.where(guild_id: data.server.id).update(channel_id: data.channel.id)
    end

    # Sets up an existing archive channel.
    def self.setup(data)
      @@PG.insert(guild_id: data.server.id, channel_id: data.channel.id)
    end

    # Gets an existing archive channel.
    def self.get(data)
      @@PG.where(guild_id: data.server.id).get(:channel_id)
    end

    # Deletes an existing archive channel.
    def self.disable(data)
      @@PG.where(guild_id: data.server.id).delete
    end
  end
end

module Frost
  # Represents a roles DB.
  class Roles
    # Easy way to access the DB.
    attr_accessor :PG

    # @param database [Sequel::Dataset]
    def initialize(database)
      @@PG = database
    end

    # Gets all the setup roles for a guild.
    def self.all(data)
      @@PG.where(guild_id: data.server.id).select(:role_id)&.map { |role| "<@&#{role[:role_id]}>" }
    end

    # Check if an existing role is setup.
    def self.get?(data)
      !@@PG.where(guild_id: data.server.id, role_id: data.options['role']).empty?
    end

    # Add a new role to the database.
    def self.add(data)
      @@PG.insert(guild_id: data.server.id, role_id: data.options['role'])
    end

    # Removes all the roles for a guild.
    def self.disable(data)
      @@PG.where(guild_id: data.server.id).delete
    end

    # Check if this guild is enable.
    def self.enabled?(data)
      !@@PG.where(guild_id: data.server.id).empty?
    end
  end
end

module Frost
  # Represents an emojis DB.
  class Emojis
    # Easy way to access the DB.
    attr_accessor :PG

    # @param database [Sequel::Dataset]
    def initialize(database)
      @@PG = database
    end

    # Add a new role to the database.
    def self.add(data)
      @@PG.insert(emoji_id: emoji.id, guild_id: server.id)
    end
  end
end

module Frost
  # Represents an snowballs DB.
  class Snowballs
    # Easy way to access the DB.
    attr_accessor :PG

    # @param database [Sequel::Dataset]
    def initialize(database)
      @@PG = database
    end

    # Checks if a user is in the Database.
    def self.user?(data)
      !@@PG.where(user_id: data.user.id).get(:user_id).nil?
    end

    # Checks if a user has a snowball.
    def self.snowball?(data)
      @@PG.where(user_id: data.user.id).get(:balance) >= 1
    end

    # Gets the snowballs a user has.
    def self.snowballs(data)
      @@PG.where(user_id: user).get(:balance)
    end

    # Adds a user to the DB.
    def self.user(data)
      @@PG.insert(user_id: data.user.id)
    end
    
    # Adds or removes a snowball.
    def self.balance(data, add = false)
      if add
        @@PG.where(user_id: data.user.id).update(balance: Sequel[:balance] + balance)
      else
        @@PG.where(user_id: data.user.id).update(balance: Sequel[:balance] - balance)
      end
    end
  end
end
