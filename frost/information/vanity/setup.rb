# frozen_string_literal: true

module Roles
  # Setup vanity roles or edit them.
  def self.setup(data)
    unless data.user.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[4])
      return
    end

    options = {
      setup_by: data.user.id,
      setup_at: Time.now.to_i,
      guild_id: data.server.id,
      role_id: data.options["role"]
    }

    guild = Guild.new(data)

    guild.edit(**options.compact)

    if guild.blank?
      data.edit_response(content: RESPONSE[11])
    else
      data.edit_response(content: RESPONSE[10])
    end
  end
end
