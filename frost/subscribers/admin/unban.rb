# frozen_string_literal: true

module AdminCommands
  # Namespace for booster admins.
  module Boosters
    def self.unban(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[6])
        return
      end

      ::Boosters::Member.new(data, lazy: true).unban

      data.edit_response(content: RESPONSE[14])
    end
  end
end
