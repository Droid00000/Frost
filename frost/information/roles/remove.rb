# frozen_string_literal: true

module Events
  # Remove a single role from the DB.
  def self.remove(data)
    unless data.user.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[18])
      return
    end

    Frost::Roles.remove(data)

    data.edit_response(content: format(RESPONSE[93], data.options["role"]))
  end
end
