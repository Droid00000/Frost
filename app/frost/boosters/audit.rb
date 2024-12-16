# frozen_string_literal: true

Rufus::Scheduler.new.cron '30 18 * * 5' do
  Frost::Boosters::Members.fetch.each do |guild_member|
    next if get_booster_status(guild_member[:guild_id], guild_member[:user_id])

    delete_guild_role(guild_member[:guild_id], guild_member[:role_id])
    Frost::Boosters::Members.delete(guild_member[:guild_id], guild_member[:user_id])
  end
end
