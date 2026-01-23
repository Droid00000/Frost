# frozen_string_literal: true

Rufus::Scheduler.s.cron "0 0 * * *" do
  Boosters::Storage.chunks.each do |chunk|
    BOT.gateway.members(chunk[:guild_id], chunk[:users])
  end

  tombstones = []

  Boosters::Storage.list_boosters do |user|
    next if BOT.member(user.guild_id, user.id)&.boosting?

    tombstones << [user.guild_id, user.id, user.version]
    BOT.remove_guild_role(user.guild, user.role_id, user.reason)
  end

  Boosters::Storage.delete_boosters(tombstones) if tombstones.any?
end
