# frozen_string_literal: true

Rufus::Scheduler.new.every "30d" do
  Frost::Emojis.prune((1..2))
end

Rufus::Scheduler.new.cron "0 0 * * *" do
  while (emoji = Frost::Emojis.drain.shift)
    Frost::Emojis.add(emoji[:emoji], emoji[:guild])
  end
end
