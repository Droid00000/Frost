# frozen_string_literal: true

# Drain all of our commands into the DB.
Rufus::Scheduler.singleton.cron "0 0 * * *" do
  Owner::Storage.drain
end
