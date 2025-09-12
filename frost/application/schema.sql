-- Revision: V2
-- Creation Date: 2025-01-02 12:31:07.804358 UTC
-- Reason: Initial Migration

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

-- Index for the `emoji_tracker` table.
CREATE INDEX IF NOT EXISTS guild_emojis_idx ON emoji_tracker (guild_id, balance DESC);

-- Function for searching for a timezone.
CREATE
OR REPLACE FUNCTION search_timezones (query TEXT) RETURNS SETOF world_timezones ROWS 25 LANGUAGE SQL STABLE AS $$
 WITH tokens AS (
    SELECT unnest(string_to_array($1, ' ')) AS t
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
ORDER BY score DESC LIMIT 25;
$$;

-- Function for fetching information about a booster.
CREATE OR REPLACE FUNCTION guild_booster (user_id BIGINT, guild_id BIGINT)
  RETURNS TABLE (
    color_id INTEGER, 
    role_id BIGINT, 
    features BIGINT, 
    user_role BIGINT, 
    banned BOOLEAN
  ) ROWS 1 LANGUAGE SQL stable AS $$ 
SELECT
   guild_boosters.color_id,
   booster_settings.role_id,
   booster_settings.features,
   guild_boosters.role_id AS user_role,
   COALESCE(banned_boosters.user_id IS NOT NULL, FALSE) AS banned
FROM
  (SELECT $1 AS user_id, $2 AS guild_id) AS params
  LEFT JOIN guild_boosters
    ON guild_boosters.user_id = params.user_id AND guild_boosters.guild_id = params.guild_id
  LEFT JOIN booster_settings
    ON booster_settings.guild_id = params.guild_id
  LEFT JOIN banned_boosters
    ON banned_boosters.user_id = params.user_id AND banned_boosters.guild_id = params.guild_id
WHERE
  guild_boosters.user_id IS NOT NULL OR booster_settings.guild_id IS NOT NULL
  OR banned_boosters.user_id IS NOT NULL LIMIT 1;
$$;

-- Foreign key for the `guild_boosters` table.
ALTER TABLE guild_boosters ADD CONSTRAINT guild_boosters_fkey FOREIGN KEY (guild_id) REFERENCES booster_settings(guild_id) ON DELETE CASCADE;