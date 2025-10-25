-- Revision: V2
-- Creation Date: 2025-01-02 12:31:07.804358 UTC
-- Reason: Initial Migration

-- Holds info about event roles.
CREATE TABLE IF NOT EXISTS event_roles (
  role_id BIGINT NOT NULL,
  guild_id BIGINT NOT NULL,
  setup_by BIGINT NOT NULL,
  setup_at BIGINT NOT NULL,
  PRIMARY KEY (guild_id, role_id)
);

-- Holds info about event users.
CREATE TABLE IF NOT EXISTS event_users (
  user_id BIGINT NOT NULL,
  role_id BIGINT NOT NULL,
  guild_id BIGINT NOT NULL,
  PRIMARY KEY (user_id, role_id)
);

-- Holds info about emoji stats.
CREATE TABLE IF NOT EXISTS emoji_tracker (
  balance INTEGER NOT NULL,
  emoji_id BIGINT NOT NULL,
  guild_id BIGINT NOT NULL,
  PRIMARY KEY (emoji_id, guild_id)
);

-- Holds info about server boosters.
CREATE TABLE IF NOT EXISTS guild_boosters (
  user_id BIGINT NOT NULL,
  role_id BIGINT NOT NULL,
  guild_id BIGINT NOT NULL,
  color_id INTEGER NOT NULL,
  PRIMARY KEY (user_id, guild_id)
);

-- Holds info about banned boosters.
CREATE TABLE IF NOT EXISTS banned_boosters (  
  user_id BIGINT NOT NULL,
  guild_id BIGINT NOT NULL,
  banned_by BIGINT NOT NULL,
  banned_at BIGINT NOT NULL,
  PRIMARY KEY (guild_id, user_id)
);

-- Holds info about world timezones.
CREATE TABLE IF NOT EXISTS world_timezones (
  name TEXT NOT NULL,
  country TEXT NOT NULL,
  timezone TEXT NOT NULL,
  identifier TEXT NOT NULL
);

-- Holds info about booster settings.
CREATE TABLE IF NOT EXISTS booster_settings (
  role_id BIGINT NOT NULL,
  features BIGINT NOT NULL,
  setup_by BIGINT NOT NULL,
  setup_at BIGINT NOT NULL,
  guild_id BIGINT PRIMARY KEY
);

-- Holds info about birthday settings.
CREATE TABLE IF NOT EXISTS birthday_settings (
  role_id BIGINT NOT NULL,
  setup_by BIGINT NOT NULL,
  setup_at BIGINT NOT NULL,
  guild_id BIGINT PRIMARY KEY,
  channel_id BIGINT DEFAULT NULL
);

-- Holds info about member birthdays.
CREATE TABLE IF NOT EXISTS user_birthdays (
  guilds BIGINT[] NOT NULL,
  user_id BIGINT PRIMARY KEY,
  pending BOOLEAN DEFAULT FALSE,
  birthdate TIMESTAMPTZ NOT NULL
);

-- Holds info about command stats.
CREATE TABLE IF NOT EXISTS command_stats (
  command_name TEXT PRIMARY KEY,
  command_users BIGINT[] NOT NULL,
  command_epochs BIGINT[] NOT NULL,
  command_channels BIGINT[] NOT NULL
);

-- Index for the `event_users` table.
CREATE INDEX IF NOT EXISTS guild_events_idx ON event_users (guild_id, user_id);

-- Index for the `event_users` table.
CREATE INDEX IF NOT EXISTS guild_events_fkey_idx ON event_users (guild_id, role_id);

-- Index for the `emoji_tracker` table.
CREATE INDEX IF NOT EXISTS guild_emojis_idx ON emoji_tracker (guild_id, balance DESC);

-- Foreign key for the `guild_boosters` table.
ALTER TABLE guild_boosters ADD CONSTRAINT guild_boosters_fkey FOREIGN KEY (guild_id) REFERENCES booster_settings(guild_id) ON DELETE CASCADE;

-- Foreign key for the `banned_boosters` table.
ALTER TABLE banned_boosters ADD CONSTRAINT banned_boosters_fkey FOREIGN KEY (guild_id) REFERENCES booster_settings(guild_id) ON DELETE CASCADE;

-- Composite foreign key for the `event_users` table.
ALTER TABLE event_users ADD CONSTRAINT event_users_fkey FOREIGN KEY (guild_id, role_id) REFERENCES event_roles(guild_id, role_id) ON DELETE CASCADE;