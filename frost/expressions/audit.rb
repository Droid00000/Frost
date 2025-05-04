# frozen_string_literal: true

# Periodically drain emojis into the DB.
Rufus::Scheduler.singleton.cron "0 */6 * * *" do
  Emojis::Storage.large?
end

# Drain all of our emojis into the DB.
Rufus::Scheduler.singleton.cron "0 0 * * *" do
  Emojis::Storage.drain
end

# Clean out ununsed emojis from the DB.
Rufus::Scheduler.singleton.cron "0 0 1 * *" do
  Emojis::Storage.prune
end
