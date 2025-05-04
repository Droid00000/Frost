# frozen_string_literal: true

module AdminCommands
  # namespace for booster admins.
  module Boosters
    # Manually removes a booster from the database.
    def self.delete(data)
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

      member.delete

      data.edit_response(content: format(RESPONSE[28], data.options["member"]))
    end
  end
end
