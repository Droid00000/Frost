# frozen_string_literal: true

module AdminCommands
  # namespace for booster admins.
  module Boosters
    # Manually adds a user to the database.
    def self.add(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[18])
        return
      end

      member = User.new(data)

      if member.guild.blank?
        data.edit_response(content: RESPONSE[34])
        return
      end

      if member.banned?
        data.edit_response(content: RESPONSE[29])
        return
      end

      member.role = data.options["role"]

      data.edit_response(content: format(RESPONSE[26], data.options["member"]))
    end
  end
end
