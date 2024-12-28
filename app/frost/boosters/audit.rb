# frozen_string_literal: true

Rufus::Scheduler.new.cron "30 18 * * 5" do
  Frost::Boosters::Members.fetch.each do |member|
    next if get_booster_status(member[:guild_id], member[:user_id])

    delete_guild_role(member[:guild_id], member[:role_id])
    Frost::Boosters::Members.delete(member[:guild_id], member[:user_id])
  end
end
