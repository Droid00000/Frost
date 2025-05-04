# frozen_string_literal: true

module AdminCommands
  # namespace for booster admins.
  module Boosters
    # Ban someone from using booster perks in a server.
    def self.ban(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[18])
        return
      end

      member = User.new(data)

      if member.guild.blank?
        data.edit_response(content: RESPONSE[34])
        return
      end

      if data.options["prune"] && !member.blank?
        data.server.role(member.role)&.delete
      end

      [member.ban, member.delete]

      data.edit_response(content: format(RESPONSE[30], data.options["member"]))
    end
  end
end
