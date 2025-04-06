# frozen_string_literal: true

module Events
  # Disable event perks for the calling server.
  def self.disable(data)
    unless data.user.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[18])
      return
    end

    Frost::Roles.disable(data)

    data.edit_response(content: RESPONSE[39])
  end
end
