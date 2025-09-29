# frozen_string_literal: true

module AdminCommands
  # Namespace for booster admins.
  module Boosters
    # Manually adds a user to the database.
    def self.add(data)
      unless data.user.permission?(:manage_server)
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

      # Resolve the role we need to add here.
      role_id = data.options["role"].to_i

      # We have to fetch the role first so we can
      # capture the base color of the pre-existing role.
      member.role = data.server.role(role_id)

      data.edit_response(content: RESPONSE[13])
    end
  end
end
