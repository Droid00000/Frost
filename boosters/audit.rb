# frozen_string_literal: true

require_relative '../data/functions'
require_relative '../data/schema'
require 'rufus-scheduler'

Rufus::Scheduler.new.cron '30 0 * * 1' do
  booster_records(type: :reset_status)
end

Rufus::Scheduler.new.cron '0 12 * * 0' do
  next_chapter_date(type: :release_date)
end

Rufus::Scheduler.new.cron '30 18 * * *' do
  booster_records(type: :get_boosters).each do |guild_member|
    next if get_booster_status(guild_member[:server_id], guild_member[:user_id])

    delete_guild_role(guild_member[:server_id], guild_member[:user_id])
    booster_records(server: guild_member[:server_id], user: guild_member[:user_id], type: :delete)
    booster_records(server: guild_member[:server_id], user: guild_member[:user_id], type: :update_status)
  end
end
