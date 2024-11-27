# frozen_string_literal: true

require 'sequel'
require 'constants'

POSTGRES = Sequel.connect(CONFIG['Postgres']['URL'])

POSTGRES.extension(:connection_validator)

POSTGRES.pool.connection_validation_timeout = -1

POSTGRES.create_table?(:Event_Settings) do
  primary_key :id
  Bigint :role_id, unique: true, null: false
  Bigint :guild_id, unique: false, null: false
  unique %i[role_id guild_id]
end

POSTGRES.create_table?(:Archiver_Settings) do
  primary_key :id
  Bigint :guild_id, null: false, unique: true
  Bigint :channel_id, null: false, unique: true
end

POSTGRES.create_table?(:Booster_Settings) do
  primary_key :id
  Bigint :guild_id, null: false, unique: true
  Bigint :hoist_role, null: false, unique: true
end

POSTGRES.create_table?(:Banned_Boosters) do
  primary_key :id
  Bigint :user_id, null: false
  Bigint :guild_id, null: false
  unique %i[guild_id user_id]
end

POSTGRES.create_table?(:Server_Boosters) do
  primary_key :id
  Bigint :user_id, null: false
  Bigint :role_id, null: false
  Bigint :guild_id, null: false
  unique %i[user_id guild_id]
end

POSTGRES.create_table?(:Snowball_Players) do
  primary_key :id
  Bigint :user_id, unique: true, null: false
  Bigint :balance, null: false, default: 0
end

def booster_records(server: nil, user: nil, role: nil, type: nil)
  POSTGRES.transaction do
    case type
    when :create
      POSTGRES[:Server_Boosters].insert(guild_id: server, user_id: user, role_id: role)
    when :delete
      POSTGRES[:Server_Boosters].where(guild_id: server, user_id: user).delete
    when :get_role
      POSTGRES[:Server_Boosters].where(guild_id: server, user_id: user).select(:role_id).map(:role_id)&.join.to_i
    when :delete_role
      POSTGRES[:Server_Boosters].where(guild_id: server, role_id: role).delete
    when :enabled
      !POSTGRES[:Booster_Settings].where(guild_id: server).select(:hoist_role).map(:hoist_role).empty?
    when :disable
      POSTGRES[:Booster_Settings].where(guild_id: server).delete
    when :setup
      POSTGRES[:Booster_Settings].insert(guild_id: server, hoist_role: role)
    when :check_user
      !POSTGRES[:Server_Boosters].where(guild_id: server, user_id: user).empty?
    when :hoist_role
      POSTGRES[:Booster_Settings].where(guild_id: server).select(:hoist_role).map(:hoist_role)&.join.to_i
    when :update_hoist_role
      POSTGRES[:Booster_Settings].where(guild_id: server).select(:hoist_role).insert(hoist_role: role)
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
      !POSTGRES[:Archiver_Settings].where(guild_id: server).select(:channel_id).map(:channel_id).empty?
    when :update
      POSTGRES[:Archiver_Settings].where(guild_id: server).update(channel_id: channel)
    when :get
      POSTGRES[:Archiver_Settings].where(guild_id: server).select(:channel_id).map(:channel_id)&.join.to_i
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
      !POSTGRES[:Event_Settings].where(guild_id: server, role_id: role).select(:role_id).map(:role_id).empty?
    when :enabled
      !POSTGRES[:Event_Settings].where(guild_id: server).empty?
    when :register_role
      POSTGRES[:Event_Settings].insert(guild_id: server, role_id: role, enabled: true)
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
    when :get_snowball
      POSTGRES[:Snowball_Players].where(user_id: user).select(:balance).map(:balance)&.join.to_i
    when :check_snowball
      POSTGRES[:Snowball_Players].where(user_id: user).select(:balance).map(:balance)&.join.to_i >= 1
    when :add_user
      POSTGRES[:Snowball_Players].insert(user_id: user, balance: 0)
    when :check_user
      !POSTGRES[:Snowball_Players].where(user_id: user).select(:user_id).map(:user_id).empty?
    end
  end
end
