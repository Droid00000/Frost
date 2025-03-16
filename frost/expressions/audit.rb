# frozen_string_literal: true

Rufus::Scheduler.new.every "30d" do
  (1..2).to_a.each do |number|
    Frost::Emojis.prune(number)
  end
end

Rufus::Scheduler.new.cron "0 0 * * *" do
  while (emoji = Frost::Emojis.drain.shift)
    Frost::Emojis.add(emoji[:emoji], emoji[:guild])
  end
end
