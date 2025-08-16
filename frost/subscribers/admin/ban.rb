# frozen_string_literal: true

module AdminCommands
  # namespace for booster admins.
  module Boosters
    # Ban someone from using booster perks in a server.
    def self.ban(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[6])
        return
      end

      member = ::Boosters::Member.new(data, lazy: true)

      if data.options["prune"] && !member.blank?
        data.server.role(member.role)&.delete
      end

      member.ban(banned_by: data.user.id,
                 banned_at: Time.now.to_i)

      data.edit_response(content: RESPONSE[15])
    end
  end
end
