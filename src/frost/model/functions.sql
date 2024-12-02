CREATE OR REPLACE FUNCTION handle_emoji_upsert()
RETURNS TRIGGER AS $$
BEGIN
  IF EXISTS (SELECT 1 FROM emoji_tracker WHERE emoji_id = NEW.emoji_id AND guild_id = NEW.guild_id) THEN
    UPDATE emoji_tracker
    SET balance = balance + NEW.balance
    WHERE emoji_id = NEW.emoji_id AND guild_id = NEW.guild_id;
    RETURN NULL;
  ELSE
    INSERT INTO emoji_tracker (emoji_id, guild_id, balance)
    VALUES (NEW.emoji_id, NEW.guild_id, NEW.balance);
    RETURN NEW;
  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER emoji_upsert_trigger
BEFORE INSERT ON emoji_tracker
FOR EACH ROW
EXECUTE FUNCTION handle_emoji_upsert();
