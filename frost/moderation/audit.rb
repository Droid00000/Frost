# frozen_string_literal: true

# Drain all of our incidents into the DB.
Rufus::Scheduler.singleton.cron "0 0 * * *" do
  Moderation::Storage.drain
end
