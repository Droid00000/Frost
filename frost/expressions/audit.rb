# frozen_string_literal: true

Rufus::Scheduler.new.every "1d" { Frost::Emojis.drain }

Rufus::Scheduler.new.every "30d" { Frost::Emojis.prune } 
