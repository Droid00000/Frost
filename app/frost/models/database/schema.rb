# frozen_string_literal: true

require 'app/frost/models/constants'

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