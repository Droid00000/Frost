-- Revision: V0
-- Creation Date: 2025-01-02 12:31:07.804358 UTC
-- Reason: Initial Migration

-- Holds info about event roles.
CREATE TABLE IF NOT EXISTS event_settings (
  role_id BIGINT NOT NULL, 
  guild_id BIGINT NOT NULL, 
  PRIMARY KEY (role_id, guild_id)
);

-- Holds info about the pin archiver.
CREATE TABLE IF NOT EXISTS archiver_settings (
  guild_id BIGINT NOT NULL UNIQUE,
  channel_id BIGINT NOT NULL UNIQUE,
  PRIMARY KEY (channel_id, guild_id)
);

-- Holds info about booster settings.
CREATE TABLE IF NOT EXISTS booster_settings (
  guild_id BIGINT NOT NULL UNIQUE,
  hoist_role BIGINT NOT NULL UNIQUE,
  PRIMARY KEY (hoist_role, guild_id)
);

-- Holds info about snowball players.
CREATE TABLE IF NOT EXISTS snowball_players (
  user_id BIGINT NOT NULL UNIQUE,
  balance BIGINT NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, balance)
);

-- Holds info about banned boosters.
CREATE TABLE IF NOT EXISTS banned_boosters (  
  user_id BIGINT NOT NULL,
  guild_id BIGINT NOT NULL,
  PRIMARY KEY (guild_id, user_id)
);

-- Holds info about server boosters.
CREATE TABLE IF NOT EXISTS guild_boosters (
  user_id BIGINT NOT NULL,
  role_id BIGINT NOT NULL,
  guild_id BIGINT NOT NULL,
  PRIMARY KEY (user_id, guild_id)
);

-- Holds info about emoji stats.
CREATE TABLE IF NOT EXISTS emoji_tracker (
  balance BIGINT DEFAULT 1,
  emoji_id BIGINT NOT NULL,
  guild_id BIGINT NOT NULL,
  PRIMARY KEY (emoji_id, guild_id)
);

-- Holds info about house settings.
CREATE TABLE IF NOT EXISTS house_settings (
  user_id BIGINT NOT NULL,
  role_id BIGINT NOT NULL,
  guild_id BIGINT NOT NULL,
  PRIMARY KEY (guild_id, user_id)
);

CREATE UNIQUE INDEX IF NOT EXISTS app_snowball_user_idx ON snowball_players (user_id);

CREATE UNIQUE INDEX IF NOT EXISTS guild_hoist_role_idx ON booster_settings (guild_id);

CREATE UNIQUE INDEX IF NOT EXISTS guild_channel_idx ON archiver_settings (guild_id);

CREATE UNIQUE INDEX IF NOT EXISTS guilds_events_idx ON event_settings (role_id);

CREATE UNIQUE INDEX IF NOT EXISTS guild_houses_idx ON house_settings (role_id);

CREATE INDEX IF NOT EXISTS guild_premium_ban_idx ON banned_boosters (guild_id);

CREATE INDEX IF NOT EXISTS guild_booster_ban_idx ON banned_boosters (user_id);

CREATE INDEX IF NOT EXISTS guild_house_head_idx ON house_settings (user_id);

CREATE INDEX IF NOT EXISTS guild_premium_idx ON guild_boosters (guild_id);

CREATE INDEX IF NOT EXISTS guild_booster_idx ON guild_boosters (user_id);

CREATE INDEX IF NOT EXISTS guilds_emoji_idx ON emoji_tracker (guild_id);

CREATE INDEX IF NOT EXISTS guild_emoji_idx ON emoji_tracker (emoji_id);
