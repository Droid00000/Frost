# frozen_string_literal: true

module Admin
  # Namespace for booster admins.
  module Boosters
    # Ban or unban multiple boosters from the guild.
    def self.banned(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[:manage_roles])
        return
      end

      unless ::Boosters::Guild.get(data.server_id)
        data.edit_response(content: RESPONSE[:unknown_guild])
        return
      end

      new_bans = if (add = data.values("add"))&.any?
                   {
                     users: add.map(&:to_i),
                     banned_by: data.user.id,
                     guild_id: data.server_id,
                     banned_at: Time.now.to_i,
                     dead: data.value("prune")&.any?
                   }
                 end

      old_bans = if (old = data.values("old"))&.any?
                   {
                     users: old.map(&:to_i),
                     guild_id: data.server_id
                   }
                 end

      if old_bans && new_bans && old_bans && new_bans
        old_bans[:users] -= new_bans[:users]
      end

      data.edit_response(content: RESPONSE[:ban_state])

      # Processing should be async so interaction doesn't timeout.
      old_bans&.[](:users)&.reject! { data.resolved.users[it]&.bot? }

      new_bans&.[](:users)&.reject! { data.resolved.users[it]&.bot? }

      # Delete all the bans first, since that's usually cheaper.
      if old_bans&.[](:users)&.any?
        ::Boosters::Storage.delete_bans(**old_bans)
      end

      return unless new_bans&.[](:users)&.any?

      new_bans = ::Boosters::Storage.create_bans(**new_bans) rescue nil

      server = data.server
      height = server.bot.sort_roles.last
      reason = "Booster Admins (ID: #{data.user.id})"

      new_bans&.each do |banned|
        role = server.role(banned.role_id)

        return unless server.bot.permission?(:manage_roles)

        role.delete(reason) if !role.nil? && (role < height)
      end
    end
  end
end
