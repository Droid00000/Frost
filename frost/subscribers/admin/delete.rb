# frozen_string_literal: true

module AdminCommands
  # namespace for booster admins.
  module Boosters
    # Manually removes a booster from the database.
    def self.delete(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[6])
        return
      end

      member = ::Boosters::Member.new(data)

      if member.guild.blank?
        data.edit_response(content: RESPONSE[4])
        return
      end

      if member.banned?
        data.edit_response(content: RESPONSE[5])
        return
      end

      if data.options["prune"] && member.role
        data.server.role(member.role)&.delete
      end

      member.delete

      data.edit_response(content: RESPONSE[11])
    end
  end
end
