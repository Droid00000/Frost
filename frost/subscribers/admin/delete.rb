# frozen_string_literal: true

module AdminCommands
  # Namespace for booster admins.
  module Boosters
    # Manually removes a booster from the database.
    def self.delete(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[6])
        return
      end

      if Boosters::Guild.get(data).nil?
        data.edit_response(content: RESPONSE[4])
        return
      end

      if (member = Boosters::Booster.get(data))&.banned?
        data.edit_response(content: RESPONSE[12])
        return
      end

      if data.options["prune"] && member&.role_id
        data.server.role(member&.role_id)&.delete
      end

      # Don't block everything else for this.
      Fiber.new { Boosters::Booster.delete(data) }.resume

      data.edit_response(content: RESPONSE[11])
    end
  end
end
