# frozen_string_literal: true

Rufus::Scheduler.s.cron "30 18 * * *" do
  Boosters::Members.chunks.each do |chunk|
    @bot.gateway.members(chunk[:guild_id], chunk[:members])
  end

  Boosters::Members.stream.each do |member|
    next if @bot.member(member[:guild_id], member[:user_id])&.boosting?

    @bot.remove_guild_role(member[:guild_id], member[:role_id])
    Boosters::Members.delete(member[:guild_id], member[:user_id])
  end
end
