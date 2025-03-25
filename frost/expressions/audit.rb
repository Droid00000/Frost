# frozen_string_literal: true

Rufus::Scheduler.new.cron "0 0 * * *" { Frost::Emojis.drain }

Rufus::Scheduler.new.every "30d" do
  (1..2).to_a.each do |numeric|
    Frost::Emojis.prune(numeric)
  end
end
