# frozen_string_literal: true

module Events
  # Manage the members for an event role.
  def self.users(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[3])
      return
    end

    unless (role = Role.get(data))
      data.edit_response(content: RESPONSE[7])
      return
    end

    # The members that we want to add.
    add = data.values("insert").map(&:to_i)

    # The members that we want to remove.
    pop = data.values("delete").map(&:to_i)

    data.edit_response(content: RESPONSE[3])

    # Exit early unless we have data.
    return unless add.any? || pop.any?

    # Deletes take priority over inserts.
    add -= pop if add.any? && pop.any?

    if add.any?
      role.add_users(users: pop) rescue nil
    end

    return unless pop.any?

    role.delete_bans(users: add) rescue nil
  end
end
