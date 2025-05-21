# frozen_string_literal: true

Rufus::Scheduler.s.cron "30 18 * * *" do
  Boosters::Members.chunks.each do |chunk|
    @bot.gateway.members(chunk[:guild_id], chunk[:members])
  end

  Boosters::Members.stream.each do |user|
    next if @bot.member(user[:guild_id], user[:user_id])&.boosting?

    Boosters::Members.delete(user[:guild_id], user[:user_id])
    @bot.remove_guild_role(user[:guild_id], user[:role_id], REASON[2])
  end
end
