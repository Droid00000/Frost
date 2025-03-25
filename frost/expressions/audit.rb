# frozen_string_literal: true

Rufus::Scheduler.new.cron "0 0 * * *" { Frost::Emojis.drain }

Rufus::Scheduler.new.cron "0 0 1 * *" { Frost::Emojis.prune } 
