# frozen_string_literal: true

module AdminCommands
  # namespace for booster admins.
  module Boosters
    def self.unban(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[6])
        return
      end

      ::Boosters::Member.new(data).unban

      data.edit_response(content: RESPONSE[13])
    end
  end
end
