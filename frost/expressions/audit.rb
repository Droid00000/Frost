# frozen_string_literal: true

Rufus::Scheduler.new.cron "0 0 * * *" do
  Frost::Emojis.drain
end

Rufus::Scheduler.new.cron "0 0 1 * *" do
  Frost::Emojis.prune
end
