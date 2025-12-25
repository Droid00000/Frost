# frozen_string_literal: true

module AdminCommands
  # Namespace for booster admins.
  module Boosters
    # Modify the banned users in the server.
    def self.ban(data)
      unless data.server.bot.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[5])
        return
      end

      if ::Boosters::Guild.get(data).nil?
        data.edit_response(content: RESPONSE[2])
        return
      end

      # The users that we want to ban.
      add = data.values("insert").map(&:to_i)

      # The users that we want to unban.
      pop = data.values("delete").map(&:to_i)

      data.edit_response(content: RESPONSE[3])

      # Exit early unless we have data.
      return unless add.any? || pop.any?

      # Deletes take priority over inserts.
      add -= pop if add.any? && pop.any?

      add_bans = {
        users: add,
        banned_by: data.user.id,
        guild_id: data.server.id,
        banned_at: Time.now.to_i
      }

      if add.any?
        ::Boosters::Storage.create_bans(**add_bans) rescue nil
      end

      pop_bans = {
        users: pop,
        guild_id: data.server.id
      }

      return unless pop.any?

      ::Boosters::Storage.delete_bans(**pop_bans) rescue nil

      # If the guild was disabled while inserting, let the user know.
    rescue Sequel::UniqueConstraintViolation
      data.edit_response(content: RESPONSE[2])
    end
  end
end
