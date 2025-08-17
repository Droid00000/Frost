# frozen_string_literal: true

Rufus::Scheduler.s.cron "0 0 * * *" do
  Boosters::Members.chunks.each do |chunk|
    BOT.gateway.members(chunk[:guild_id], chunk[:members])
  end

  Boosters::Members.stream.each do |user|
    next if BOT.member(user[:guild_id], user[:user_id])&.boosting?

    Boosters::Members.delete(**user.slice(:guild_id, :user_id))
    BOT.remove_guild_role(user[:guild_id], user[:role_id], user[:reason])
  end
end
