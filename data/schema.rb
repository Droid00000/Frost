# frozen_string_literal: true

require 'sequel'
require 'toml-rb'
require_relative 'constants'

POSTGRES = Sequel.connect(TOML['Postgres']['URL'], max_connections: 7)

POSTGRES.create_table?(:Event_Settings) do
  primary_key :id
  Boolean :enabled, null: false
  Bigint :banned_users, null: false
  Bigint :role_id, unique: true, null: false
  Bigint :server_id, unique: false, null: false
  unique %i[role_id server_id]
end

POSTGRES.create_table?(:Archiver_Settings) do
  primary_key :id
  Boolean :enabled, null: false, default: false
  Bigint :server_id, null: false, unique: true
  Bigint :channel_id, null: false, unique: true
end

POSTGRES.create_table?(:Booster_Settings) do
  primary_key :id
  Boolean :enabled, null: false
  Bigint :server_id, null: false, unique: true
  Bigint :hoist_role, null: false, unique: true
end

POSTGRES.create_table?(:Banned_Boosters) do
  primary_key :id
  Bigint :user_id, null: false
  Bigint :server_id, null: false
  unique %i[server_id user_id]
end

POSTGRES.create_table?(:Server_Boosters) do
  primary_key :id
  Bigint :user_id, null: false
  Boolean :status, null: false
  Bigint :server_id, null: false
  Bigint :role_id, null: false, unique: true
  unique %i[user_id server_id]
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
      POSTGRES[:Server_Boosters].insert(server_id: server, user_id: user, role_id: role, status: true)
    when :delete
      POSTGRES[:Server_Boosters].where(server_id: server, user_id: user).delete
    when :get_role
      POSTGRES[:Server_Boosters].where(server_id: server, user_id: user).select(:role_id).map(:role_id)&.join.to_i
    when :enabled
      !POSTGRES[:Booster_Settings].where(server_id: server).select(:enabled).map(:enabled).empty?
    when :disable
      POSTGRES[:Booster_Settings].where(server_id: server).delete
    when :setup
      POSTGRES[:Booster_Settings].insert(server_id: server, hoist_role: role, enabled: true)
    when :check_user
      !POSTGRES[:Server_Boosters].where(server_id: server, user_id: user).empty?
    when :hoist_role
      POSTGRES[:Booster_Settings].where(server_id: server).select(:hoist_role).map(:hoist_role)&.join.to_i
    when :update_hoist_role
      POSTGRES[:Booster_Settings].where(server_id: server).select(:hoist_role).insert(hoist_role: role)
    when :banned
      !POSTGRES[:Banned_Boosters].where(server_id: server, user_id: user).empty?
    when :ban
      POSTGRES[:Banned_Boosters].insert(server_id: server, user_id: user)
    when :unban
      POSTGRES[:Banned_Boosters].where(server_id: server, user_id: user).delete
    when :reset_status
      POSTGRES[:Server_Boosters].where(status: false).insert(status: true)
    when :update_status
      POSTGRES[:Server_Boosters].where(server_id: server, user_id: user, status: false).insert(status: true)
    when :get_boosters
      POSTGRES[:Server_Boosters].where(status: false)
    end
  end
end

def archiver_records(server: nil, channel: nil, type: nil)
  POSTGRES.transaction do
    case type
    when :check
      !POSTGRES[:Archiver_Settings].where(server_id: server).select(:channel_id).map(:channel_id).empty?
    when :update
      POSTGRES[:Archiver_Settings].where(server_id: server).insert(channel_id: channel)
    when :get
      POSTGRES[:Archiver_Settings].where(server_id: server).select(:channel_id).map(:channel_id)&.join.to_i
    when :setup
      POSTGRES[:Archiver_Settings].insert(server_id: server, channel_id: channel, enabled: true)
    when :disable
      POSTGRES[:Archiver_Settings].where(server_id: server).delete
    end
  end
end

def event_records(server: nil, role: nil, type: nil)
  POSTGRES.transaction do
    case type
    when :check_role
      !POSTGRES[:Event_Settings].where(server:, role:).select(:role_id).map(:role_id).empty?
    when :enabled
      !POSTGRES[:Event_Settings].where(server_id: server).select(:enabled).map(:enabled).empty?
    when :enable
      POSTGRES[:Event_Settings].insert(server_id: server, role_id: role, enabled: true)
    when :register_role
      POSTGRES[:Event_Settings].insert(server_id: server, role_id: role)
    when :disable
      POSTGRES[:Event_Settings].where(server_id: server).delete
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
      return true if POSTGRES[:Snowball_Players].where(user_id: user).select(:balance).map(:balance)&.join.to_i >= 1
    when :add_user
      POSTGRES[:Snowball_Players].insert(user_id: user, balance: 0)
    when :check_user
      !POSTGRES[:Snowball_Players].where(user_id: user).select(:user_id).map(:user_id).empty?
    end
  end
end
