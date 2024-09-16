# frozen_string_literal: true

require 'sequel'
require 'toml-rb'
require './data/constants'

POSTGRES = Sequel.connect('postgres://localhost/frigid', user: TOML['Postgres']['USERNAME'], password: TOML['Postgres']['PASSWORD'])

POSTGRES.create_table?(:Event_Settings) do
  primary_key :id
  Boolean :enabled, null: false
  Bigint :banned_users, null: false
  Bigint :role_id, unique: true, null: false
  Bigint :server_id, unique: true, null: false
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
  Bigint :log_channel, null: true, unique: true
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
  Bigint :role_id, null: false
  Bigint :server_id, null: false
  Boolean :boosting, null: false
  unique %i[user_id server_id]
end

POSTGRES.create_table?(:Snowball_Players) do
  primary_key :id
  Bigint :user_id, unique: true, null: false
  Bigint :balance, null: false, default: 0
  Bigint :powerups, null: false, default: 0
end

POSTGRES.create_table?(:Tags) do
  primary_key :id
  Bigint :owner_id, null: false
  Bigint :server_id, null: false
  Bigint :channel_id, null: false
  String :name, null: false, unique: true 
  Bigint :message_id, unique: true, null: false
end

POSTGRES.create_table?(:Tag_Settings) do
  primary_key :id
  Bigint :server_id, null: false
  Boolean :enabled, null: false, default: true
end

def booster_records(server: nil, user: nil, role: nil, channel: nil, type: nil)
  case type
  when :create
    POSTGRES[:Server_Boosters].insert(server_id: server, user_id: user, role_id: role)
  when :delete
    POSTGRES[:Server_Boosters].where(server_id: server, user_id: user).delete
  when :get_role
    POSTGRES[:Server_Boosters].where(server_id: server, user_id: user).select(:role_id).map(:role_id)
  when :enabled
    !POSTGRES[:Booster_Settings].where(server_id: server).select(:enabled).map(:enabled).empty? 
  when :setup
    POSTGRES[:Booster_Settings].insert(server_id: server, hoist_role: role, log_channel: channel, enabled: true)
  when :check_user  
    !POSTGRES[:Server_Boosters].where(server_id: server, user_id: user).empty?
  when :hoist_role  
    POSTGRES[:Booster_Settings].where(server_id: server).select(:hoist_role).map(:hoist_role)
  when :banned
    ![:Banned_Boosters].where(server_id: server, user_id: user).empty? 
  when :ban
    POSTGRES[:Banned_Boosters].insert(server_id: server, user_id: user)
  else
    nil
  end
end

def archiver_records(server: nil, channel: nil, type: nil)
  case type
  when :check
    !POSTGRES[:Archiver_Settings].where(server_id: server).select(:channel_id).map(:channel_id).empty?
  when :get
    POSTGRES[:Archiver_Settings].where(server_id: server).select(:channel_id).map(:channel_id)
  when :setup
    POSTGRES[:Archiver_Settings].insert(server_id: server, channel_id: channel, enabled: true)
  when :disable
    POSTGRES[:Archiver_Settings].where(server_id: server).delete
  else
    nil
  end
end

def tag_records(name: nil, server: nil, message: nil, owner: nil, type: nil)
  case type
  when :enabled
    POSTGRES[:Tag_Settings].where(server_id: server).select(:enabled).map(:enabled).empty?
  when :get
    [POSTGRES[:Tags].where(name: name).select(:message_id).map(:message_id), POSTGRES[:Tags].where(name: name).select(:channel_id).map(:channel_id)]
  when :disable
    POSTGRES[:Tag_Settings].insert(server_id: server, enabled: false)
  when :create
    POSTGRES[:Tags].insert(server_id: server, message_id: message, name: name, owner_id: owner, channel_id: channel)
  else
    nil
  end
end