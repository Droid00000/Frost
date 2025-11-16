# frozen_string_literal: true

Rufus::Scheduler.s.cron "0 0 * * *" do
  Boosters::Storage.chunks.each do |chunk|
    BOT.gateway.members(chunk[:guild_id], chunk[:users])
  end

  Boosters::Storage.list_boosters do |user|
    next if BOT.member(user.guild_id, user.id)&.boosting?

    BOT.remove_guild_role(user.guild_id, user.role_id, user.reason)
    Boosters::Storage.remove_booster(guild_id: user.guild_id, user_id: user.id)
  end
end
