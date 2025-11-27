# frozen_string_literal: true

module Events
  # Responses and fields for event roles.
  RESPONSE = {
    1 => "You've successfully un-equipped the <@&%s> role! <a:YorClap_Maomao:1287269908157038592>",
    2 => "You've successfully equipped the <@&%s> role! <a:YorClap_Maomao:1287269908157038592>",
    3 => "The bot needs to have the `manage roles` permission to do this.",
    4 => "You do not have permission to un-equip this role.",
    5 => "You do not have permission to equip this role.",
    6 => "This role cannot be un-equipped.",
    7 => "This role cannot be equipped."
  }.freeze

  # Suppress mentions for event roles.
  MENTIONS = { allowed_mentions: { parse: [] } }.freeze

  # Add an event role to a member.
  def self.edit_roles(role, member)
    roles = (member.roles + [role])

    roles = roles.uniq.sort_by do |role|
      [role.position, role.resolve_id]
    end

    max = member.server.bot.sort_roles.last

    role_index = roles.rindex(role.resolve_id)

    roles = roles.reject.with_index do |role, idx|
      next nil if max && role.position > max.position

      Storage.role?(role_id: role) && idx > role_index
    end

    member.set_roles(roles, "Event Roles") rescue false
  end
end
