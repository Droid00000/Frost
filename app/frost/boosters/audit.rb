# frozen_string_literal: true

Rufus::Scheduler.new.cron '30 18 * * 5' do
  Frost::Boosters::Members.get.each do |guild_member|
    next if get_booster_status(guild_member[:guild_id], guild_member[:user_id])

    delete_guild_role(guild_member[:guild_id], guild_member[:role_id])
    booster_records(server: guild_member[:guild_id], user: guild_member[:user_id], type: :delete)
  end
end
