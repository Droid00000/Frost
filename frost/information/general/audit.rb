# frozen_string_literal: true

Rufus::Scheduler.singleton.cron "19 15 * * *" do
  # Update the channel with the chapter date.
  General.find_chapter
end
