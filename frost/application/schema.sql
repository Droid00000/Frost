-- Revision: V2
-- Creation Date: 2025-01-02 12:31:07.804358 UTC
-- Reason: Initial Migration

-- Holds info about emoji stats.
CREATE TABLE IF NOT EXISTS emoji_tracker (
  balance BIGINT DEFAULT 1,
  emoji_id BIGINT NOT NULL,
  guild_id BIGINT NOT NULL,
  PRIMARY KEY (emoji_id, guild_id)
);

-- Holds info about event roles.
CREATE TABLE IF NOT EXISTS event_settings (
  role_id BIGINT NOT NULL, 
  guild_id BIGINT NOT NULL,
  any_icon BOOLEAN NOT NULL,
  PRIMARY KEY (role_id, guild_id)
);

-- Holds info about world timezones.
CREATE TABLE IF NOT EXISTS world_timezones (
  name TEXT NOT NULL,
  country TEXT NOT NULL,
  timezone TEXT NOT NULL,
  identifier TEXT NOT NULL,
  PRIMARY KEY (timezone, name)
);

-- Holds info about server boosters.
CREATE TABLE IF NOT EXISTS guild_boosters (
  user_id BIGINT NOT NULL,
  role_id BIGINT NOT NULL,
  guild_id BIGINT NOT NULL,
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


-- Holds info about booster settings.
CREATE TABLE IF NOT EXISTS booster_settings (
  setup_by BIGINT NOT NULL,
  setup_at BIGINT NOT NULL,
  any_icon BOOLEAN NOT NULL,
  guild_id BIGINT PRIMARY KEY,
  hoist_role BIGINT NOT NULL UNIQUE
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
  guilds BIGINT NOT NULL,
  user_id BIGINT PRIMARY KEY,
  pending BOOLEAN DEFAULT FALSE,
  birthdate TIMESTAMPTZ NOT NULL
);

-- Function for searching for a timezone.
CREATE
OR REPLACE FUNCTION search_timezones (query text) RETURNS SETOF world_timezones ROWS 25 LANGUAGE SQL STABLE AS $$
 WITH tokens AS (
    SELECT unnest(string_to_array(unaccent($1), ' ')) AS t
)
SELECT name, country, timezone, identifier
FROM (
    SELECT
        g.*,
        (
            SELECT SUM(
                CASE WHEN g.name ILIKE '%' || t.t || '%' THEN 1.0 - (t.t <-> g.name) ELSE 0 END +
                CASE WHEN similarity(g.name, t.t) > 0.2 THEN similarity(g.name, t.t) ELSE 0 END +
                CASE WHEN g.country ILIKE '%' || t.t || '%' THEN 1.0 - (t.t <-> g.country) ELSE 0 END +
                CASE WHEN similarity(g.country, t.t) > 0.2 THEN similarity(g.country, t.t) ELSE 0 END +
                CASE WHEN g.timezone ILIKE '%' || t.t || '%' THEN 1.0 - (t.t <-> g.timezone) ELSE 0 END +
                CASE WHEN similarity(g.timezone, t.t) > 0.2 THEN similarity(g.timezone, t.t) ELSE 0 END +
                CASE WHEN g.identifier ILIKE '%' || t.t || '%' THEN 1.0 - (t.t <-> g.identifier) ELSE 0 END +
                CASE WHEN similarity(g.identifier, t.t) > 0.2 THEN similarity(g.identifier, t.t) ELSE 0 END
            )
            FROM tokens t
        ) AS score
    FROM world_timezones g
) sub
ORDER BY score DESC
LIMIT 25;
$$;

-- Index for the `emoji_tracker` table.
CREATE INDEX IF NOT EXISTS guild_emojis_idx ON emoji_tracker (guild_id, balance DESC);

-- GIN indexes for the `world_timezones` table.
CREATE INDEX IF NOT EXISTS world_names_idx ON world_timezones USING GIN (name gin_trgm_ops);

CREATE INDEX IF NOT EXISTS world_codes_idx ON world_timezones USING GIN (identifier gin_trgm_ops);

CREATE INDEX IF NOT EXISTS world_countries_idx ON world_timezones USING GIN (country gin_trgm_ops);

CREATE INDEX IF NOT EXISTS world_timezones_idx ON world_timezones USING GIN (timezone gin_trgm_ops);