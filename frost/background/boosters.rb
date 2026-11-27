# frozen_string_literal: true

Rufus::Scheduler.singleton.cron "0 17 * * *" do
  BOT.boosters_cache.guilds.each(&:audit_boosters)
end
