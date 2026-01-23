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
  def self.edit_roles(add, member)
    pop, top = [], member.server.bot.highest_role

    member.roles.uniq.each do |role|
      next if top && (role > top) || !Storage.role?(role_id: role.id)

      (pop << role) if role > add
    end

    member.set_roles(((member.roles - pop) + [add]).uniq, "Event Roles") rescue nil
  end
end
