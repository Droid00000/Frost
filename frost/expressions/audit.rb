# frozen_string_literal: true

Rufus::Scheduler.new.cron "0 0 * * *" { Frost::Emojis.drain }

Rufus::Scheduler.new.every "30d" { Frost::Emojis.prune } 
