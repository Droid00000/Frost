-- Revision: V2
-- Creation Date: 2025-01-02 12:31:07.804358 UTC
-- Reason: Initial Migration

-- Holds info about event roles.
CREATE TABLE IF NOT EXISTS event_settings (
  role_id BIGINT NOT NULL, 
  guild_id BIGINT NOT NULL,
  any_icon BOOLEAN NOT NULL,
  PRIMARY KEY (role_id, guild_id)
);

-- Holds info about world timezones.
CREATE TABLE IF NOT EXISTS guild_timezones (
  name TEXT NOT NULL,
  country TEXT NOT NULL,
  timezone TEXT NOT NULL,
  identifier TEXT NOT NULL,
  PRIMARY KEY (timezone, name)
);

-- Holds info about the pin archiver.
CREATE TABLE IF NOT EXISTS archiver_settings (
  setup_by BIGINT NOT NULL,
  setup_at BIGINT NOT NULL,
  guild_id BIGINT NOT NULL UNIQUE,
  channel_id BIGINT NOT NULL UNIQUE,
  PRIMARY KEY (channel_id, guild_id)
);

-- Holds info about booster settings.
CREATE TABLE IF NOT EXISTS booster_settings (
  setup_by BIGINT NOT NULL,
  setup_at BIGINT NOT NULL,
  any_icon BOOLEAN NOT NULL,
  guild_id BIGINT NOT NULL UNIQUE,
  hoist_role BIGINT NOT NULL UNIQUE,
  PRIMARY KEY (hoist_role, guild_id)
);

-- Holds info about birthday settings.
CREATE TABLE IF NOT EXISTS birthday_settings (
  role_id BIGINT NOT NULL,
  setup_by BIGINT NOT NULL,
  setup_at BIGINT NOT NULL,
  guild_id BIGINT NOT NULL,
  channel_id BIGINT DEFAULT NULL,
  PRIMARY KEY (role_id, guild_id)
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

-- Holds info about member birthdays.
CREATE TABLE IF NOT EXISTS guild_birthdays (
  active BOOLEAN NOT NULL,
  user_id BIGINT NOT NULL,
  guild_ids BIGINT[] NOT NULL,
  birthday TIMESTAMPTZ NOT NULL,
  PRIMARY KEY (birthday, user_id)
);

-- Holds info about emoji stats.
CREATE TABLE IF NOT EXISTS emoji_tracker (
  balance BIGINT DEFAULT 1,
  emoji_id BIGINT NOT NULL,
  guild_id BIGINT NOT NULL,
  PRIMARY KEY (emoji_id, guild_id)
);

-- Holds info about the reminders.
CREATE TABLE IF NOT EXISTS reminders (
  content TEXT NOT NULL,
  user_id BIGINT NOT NULL,
  one_time BOOLEAN NOT NULL,
  identifier BIGINT NOT NULL,
  recurrence INTERVAL NOT NULL,
  deliver_at TIMESTAMP NOT NULL,
  PRIMARY KEY (user_id, identifier)
);

-- Function for searching for a timezone.
CREATE OR REPLACE FUNCTION search_timezones (query text)
    RETURNS SETOF guild_timezones
    AS $$
BEGIN
    RETURN query WITH tokens AS (
        SELECT
            unnest(string_to_array(query, ' ')) AS t
)
    SELECT
        NAME,
        country,
        timezone,
        identifier
    FROM
        guild_timezones,
        tokens
    WHERE (NAME ILIKE '%' || tokens.t || '%'
        OR similarity (NAME, tokens.t) > 0.2)
        OR (country ILIKE '%' || tokens.t || '%'
            OR similarity (country, tokens.t) > 0.2)
        OR (timezone ILIKE '%' || tokens.t || '%'
            OR similarity (timezone, tokens.t) > 0.2)
        OR (identifier ILIKE '%' || tokens.t || '%'
            OR similarity (identifier, tokens.t) > 0.2)
    GROUP BY
        NAME,
        country,
        timezone,
        identifier
    ORDER BY
        sum(
            CASE WHEN NAME ILIKE '%' || tokens.t || '%' THEN
                1.0 - (tokens.t <-> NAME)
            ELSE
                0
            END + CASE WHEN similarity (NAME, tokens.t) > 0.2 THEN
                similarity (NAME, tokens.t)
            ELSE
                0
            END + CASE WHEN country ILIKE '%' || tokens.t || '%' THEN
                1.0 - (tokens.t <-> country)
            ELSE
                0
            END + CASE WHEN similarity (country, tokens.t) > 0.2 THEN
                similarity (country, tokens.t)
            ELSE
                0
            END + CASE WHEN timezone ILIKE '%' || tokens.t || '%' THEN
                1.0 - (tokens.t <-> timezone)
            ELSE
                0
            END + CASE WHEN similarity (timezone, tokens.t) > 0.2 THEN
                similarity (timezone, tokens.t)
            ELSE
                0
            END + CASE WHEN identifier ILIKE '%' || tokens.t || '%' THEN
                1.0 - (tokens.t <-> identifier)
            ELSE
                0
            END + CASE WHEN similarity (identifier, tokens.t) > 0.2 THEN
                similarity (identifier, tokens.t)
            ELSE
                0
            END) DESC
    LIMIT 25;
END;

-- Function for managing the balance of an emoji.
CREATE OR REPLACE FUNCTION balance_manager() RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (SELECT FROM emoji_tracker WHERE emoji_id = NEW.emoji_id AND guild_id = NEW.guild_id) THEN
        UPDATE emoji_tracker
        SET balance = balance + 1
        WHERE emoji_id = NEW.emoji_id AND guild_id = NEW.guild_id;
        RETURN NULL;
    ELSE
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE PLPGSQL;

-- Indexes for the `guild_boosters` table.
CREATE INDEX IF NOT EXISTS guild_booster_idx ON guild_boosters (user_id);

CREATE INDEX IF NOT EXISTS guild_premium_idx ON guild_boosters (guild_id);

-- Indexes for the `banned_boosters` table.
CREATE INDEX IF NOT EXISTS guild_booster_ban_idx ON banned_boosters (user_id);

CREATE INDEX IF NOT EXISTS guild_premium_ban_idx ON banned_boosters (guild_id);

-- Indexes for the `emoji_tracker` table.
CREATE INDEX IF NOT EXISTS guild_emoji_idx ON emoji_tracker (emoji_id);

CREATE INDEX IF NOT EXISTS guilds_emoji_idx ON emoji_tracker (guild_id);

CREATE INDEX IF NOT EXISTS guild_emoji_balance_idx ON emoji_tracker (balance);

-- Indexes for the `guild_birthdays` table.
CREATE INDEX IF NOT EXISTS guild_birthdays_idx ON guild_birthdays (guild_ids);

CREATE INDEX IF NOT EXISTS guild_birthday_user_idx ON guild_birthdays (user_id);

CREATE INDEX IF NOT EXISTS guild_birthday_date_idx ON guild_birthdays (birthday);

CREATE INDEX IF NOT EXISTS guild_birthdays_status_idx ON guild_birthdays (active);

-- Indexes for the `birthday_settings` table.
CREATE INDEX IF NOT EXISTS guild_birthday_idx ON birthday_settings (guild_id);

CREATE INDEX IF NOT EXISTS guild_birthday_role_idx ON birthday_settings (role_id);

CREATE INDEX IF NOT EXISTS guild_birthday_epoch_idx ON birthday_settings (setup_at);

CREATE INDEX IF NOT EXISTS guild_birthday_creator_idx ON birthday_settings (setup_by);

CREATE INDEX IF NOT EXISTS guild_birthday_channel_idx ON birthday_settings (channel_id);

-- Indexes for the `archiver_settings` table.
CREATE INDEX IF NOT EXISTS guild_pins_epoch_idx ON archiver_settings (setup_at);

CREATE UNIQUE INDEX IF NOT EXISTS guild_pins_idx ON archiver_settings (guild_id);

CREATE INDEX IF NOT EXISTS guild_pins_manager_idx ON archiver_settings (setup_by);

CREATE UNIQUE INDEX IF NOT EXISTS guild_channel_idx ON archiver_settings (channel_id);

-- Indexes for the `booster_settings` table.
CREATE INDEX IF NOT EXISTS guild_icon_idx ON booster_settings (any_icon);

CREATE INDEX IF NOT EXISTS guild_booster_role_idx ON booster_settings (hoist_role);

CREATE INDEX IF NOT EXISTS guild_booster_manager_idx ON booster_settings (setup_by);

CREATE INDEX IF NOT EXISTS guild_booster_creation_idx ON booster_settings (setup_at);

CREATE UNIQUE INDEX IF NOT EXISTS guild_hoist_role_idx ON booster_settings (guild_id);

-- Indexes for the `guild_timezones` table.
CREATE INDEX IF NOT EXISTS guild_names_idx ON guild_timezones USING GIN (name gin_trgm_ops);

CREATE INDEX IF NOT EXISTS guild_codes_idx ON guild_timezones USING GIN (identifier gin_trgm_ops);

CREATE INDEX IF NOT EXISTS guild_countries_idx ON guild_timezones USING GIN (country gin_trgm_ops);

CREATE INDEX IF NOT EXISTS guild_timezones_idx ON guild_timezones USING GIN (timezone gin_trgm_ops);

-- Triggers for suppressing redundant updates across almost all of our tables.
CREATE TRIGGER guild_emoji_udx BEFORE INSERT ON emoji_tracker FOR EACH ROW EXECUTE FUNCTION balance_manager();

CREATE TRIGGER guild_events_udx BEFORE UPDATE ON event_settings FOR EACH ROW EXECUTE FUNCTION suppress_redundant_updates_trigger();

CREATE TRIGGER guild_channel_udx BEFORE UPDATE ON archiver_settings FOR EACH ROW EXECUTE FUNCTION suppress_redundant_updates_trigger();

CREATE TRIGGER guild_hoist_role_udx BEFORE UPDATE ON booster_settings FOR EACH ROW EXECUTE FUNCTION suppress_redundant_updates_trigger();

CREATE TRIGGER guild_booster_ban_udx BEFORE UPDATE ON banned_boosters FOR EACH ROW EXECUTE FUNCTION suppress_redundant_updates_trigger();