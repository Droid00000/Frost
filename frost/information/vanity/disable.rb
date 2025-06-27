# frozen_string_literal: true

module Vanity
  # Disable vanity roles for a server.
  def self.disable(data)
    unless data.user.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[4])
      return
    end

    Guild.new(data, lazy: true).delete

    data.edit_response(content: RESPONSE[12])
  end
end
