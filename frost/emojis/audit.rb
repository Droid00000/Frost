# frozen_string_literal: true

Rufus::Scheduler.new.cron "0 0 * * *" do
  while (emoji = Frost::Emojis.drain.shift)
    Frost::Emojis.add(emoji[:emoji], emoji[:guild])
  end
end
