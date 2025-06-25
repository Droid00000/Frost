# frozen_string_literal: true

# Periodically drain emojis into the DB.
Rufus::Scheduler.singleton.cron "0 */6 * * *" do
  Emojis::Storage.large?
end

# Drain all of our emojis into the DB.
Rufus::Scheduler.singleton.cron "0 0 * * *" do
  Emojis::Storage.drain
end
