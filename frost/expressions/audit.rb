# frozen_string_literal: true

# Drain all of our emojis into the DB.
Rufus::Scheduler.new.cron "0 0 * * *" do
  Frost::Emojis.drain
end

# Clean out ununsed emojis from the DB.
Rufus::Scheduler.new.cron "0 0 1 * *" do
  Frost::Emojis.prune
end
