# frozen_string_literal: true

module AdminCommands
  # namespace for booster admins.
  module Boosters
    def self.unban(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[18])
        return
      end

      member = User.new(data).unban

      data.edit_response(content: format(RESPONSE[32], data.options["member"]))
    end
  end
end
