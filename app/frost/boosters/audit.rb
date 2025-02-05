# frozen_string_literal: true

Rufus::Scheduler.new.cron "30 18 * * *" do
  Frost::Boosters::Members.chunks.each do |chunk|
    @bot.gateway.members(chunk[:guild_id], chunk[:members])
  end

  Frost::Boosters::Members.fetch.each do |member|
    puts "#{member[:user_id]} --- #{member[:guild_id]}"

    next if @bot.member(member[:guild_id], member[:user_id])&.boosting?

    delete_guild_role(member[:guild_id], member[:role_id])
    Frost::Boosters::Members.prune(member[:guild_id], member[:user_id])
  end
end
