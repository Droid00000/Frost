# frozen_string_literal: true

module AdminCommands
  # namespace for booster admins.
  module Boosters
    # Manually adds a user to the database.
    def self.add(data)
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

      member.role = data.options["role"]

      data.edit_response(content: RESPONSE[12])
    end
  end
end
