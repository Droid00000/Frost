# frozen_string_literal: true

require 'sequel'
require 'constants'

POSTGRES = Sequel.connect(CONFIG['Postgres']['URL'])

POSTGRES.extension(:connection_validator)

POSTGRES.pool.connection_validation_timeout = -1

POSTGRES.create_table?(:Event_Settings) do
  Bigint :role_id, unique: true, null: false
  Bigint :guild_id, unique: false, null: false
  primary_key %i[role_id guild_id]
end

POSTGRES.create_table?(:Archiver_Settings) do
  Bigint :guild_id, null: false, unique: true
  Bigint :channel_id, null: false, unique: true
  primary_key %i[channel_id guild_id]
end

POSTGRES.create_table?(:Booster_Settings) do
  Bigint :guild_id, null: false, unique: true
  Bigint :hoist_role, null: false, unique: true
  primary_key %i[hoist_role guild_id]
end

POSTGRES.create_table?(:Snowball_Players) do
  Bigint :user_id, unique: true, null: false
  Bigint :balance, null: false, default: 0
  primary_key %i[user_id balance]
end

POSTGRES.create_table?(:Banned_Boosters) do
  Bigint :user_id, null: false
  Bigint :guild_id, null: false
  primary_key %i[guild_id user_id]
end

POSTGRES.create_table?(:Server_Boosters) do
  Bigint :user_id, null: false
  Bigint :role_id, null: false
  Bigint :guild_id, null: false
  primary_key %i[user_id guild_id]
end

def booster_records(server: nil, user: nil, role: nil, type: nil)
  POSTGRES.transaction do
    case type
    when :create
      POSTGRES[:Server_Boosters].insert(guild_id: server, user_id: user, role_id: role)
    when :delete
      POSTGRES[:Server_Boosters].where(guild_id: server, user_id: user).delete
    when :get_role
      POSTGRES[:Server_Boosters].where(guild_id: server, user_id: user).get(:role_id)
    when :delete_role
      POSTGRES[:Server_Boosters].where(guild_id: server, role_id: role).delete
    when :enabled
      !POSTGRES[:Booster_Settings].where(guild_id: server).get(:hoist_role).nil?
    when :disable
      POSTGRES[:Booster_Settings].where(guild_id: server).delete
    when :setup
      POSTGRES[:Booster_Settings].insert(guild_id: server, hoist_role: role)
    when :check_user
      !POSTGRES[:Server_Boosters].where(guild_id: server, user_id: user).empty?
    when :hoist_role
      POSTGRES[:Booster_Settings].where(guild_id: server).get(:hoist_role)
    when :update_hoist_role
      POSTGRES[:Booster_Settings].where(guild_id: server).update(hoist_role: role)
    when :banned
      !POSTGRES[:Banned_Boosters].where(guild_id: server, user_id: user).empty?
    when :ban
      POSTGRES[:Banned_Boosters].insert(guild_id: server, user_id: user)
    when :unban
      POSTGRES[:Banned_Boosters].where(guild_id: server, user_id: user).delete
    when :get_boosters
      POSTGRES[:Server_Boosters]
    end
  end
end

def archiver_records(server: nil, channel: nil, type: nil)
  POSTGRES.transaction do
    case type
    when :check
      POSTGRES[:Archiver_Settings].where(guild_id: server).get(:channel_id)
    when :update
      POSTGRES[:Archiver_Settings].where(guild_id: server).update(channel_id: channel)
    when :get
      POSTGRES[:Archiver_Settings].where(guild_id: server).get(:channel_id)
    when :setup
      POSTGRES[:Archiver_Settings].insert(guild_id: server, channel_id: channel)
    when :disable
      POSTGRES[:Archiver_Settings].where(guild_id: server).delete
    end
  end
end

def event_records(server: nil, role: nil, type: nil)
  POSTGRES.transaction do
    case type
    when :get_roles
      POSTGRES[:Event_Settings].where(guild_id: server).select(:role_id)&.map { |role| "<@&#{role[:role_id]}>" }
    when :check_role
      !POSTGRES[:Event_Settings].where(guild_id: server, role_id: role).empty?
    when :register_role
      POSTGRES[:Event_Settings].insert(guild_id: server, role_id: role)
    when :enabled
      !POSTGRES[:Event_Settings].where(guild_id: server).empty?
    when :disable
      POSTGRES[:Event_Settings].where(guild_id: server).delete
    end
  end
end

def snowball_records(user: nil, type: nil, balance: nil)
  POSTGRES.transaction do
    case type
    when :add_snowball
      POSTGRES[:Snowball_Players].where(user_id: user).update(balance: Sequel[:balance] + balance)
    when :remove_snowball
      POSTGRES[:Snowball_Players].where(user_id: user).update(balance: Sequel[:balance] - balance)
    when :check_user
      !POSTGRES[:Snowball_Players].where(user_id: user).get(:user_id).nil?
    when :check_snowball
      POSTGRES[:Snowball_Players].where(user_id: user).get(:balance) >= 1
    when :get_snowball
      POSTGRES[:Snowball_Players].where(user_id: user).get(:balance)
    when :add_user
      POSTGRES[:Snowball_Players].insert(user_id: user)
    end
  end
end
