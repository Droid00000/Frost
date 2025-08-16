# frozen_string_literal: true

# Drain all of our emojis into the DB.
Rufus::Scheduler.singleton.cron "0 0 * * *" do
  Emojis::Storage.drain
end
