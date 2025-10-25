# frozen_string_literal: true

module Events
  # Responses and fields for event roles.
  RESPONSE = {
    1 => "You've successfully un-toggled to the <@&%s> role! <a:YorClap_Maomao:1287269908157038592>",
    2 => "You've successfully toggled the <@&%s> role! <a:YorClap_Maomao:1287269908157038592>",
    3 => "The bot needs to have the `manage roles` permission to do this.",
    4 => "You do not have permission to interact with this role.",
    5 => "The bot does not have permission to manage your roles.",
    6 => "This role hasn't been configured to be un-toggleable.",
    7 => "This role hasn't been configured to be toggleable."
  }.freeze

  # Suppress mentions for event roles.
  MENTIONS = { allowed_mentions: { parse: [] } }.freeze

  # Update the event roles for a member, accounting for hierarchy.
  # @param data [Discordrb::Events::Interaction] The interaction context.
  # @param member [Events::Member] The database member for the ineraction.
  def self.update_roles(data, member)
    # Store all of the current roles for the member.
    old_roles = data.user.roles

    # Ensure the array contains the operating role.
    unless old_roles.include?(member.role_id)
      old_roles << data.server.role(member.role_id)
    end

    # Sort the roles according to their position.
    old_roles.sort_by! { [it.position, it.id] }

    # Get the index of the current role if exists.
    new_index = old_roles.rindex(member.role_id)

    # Then remove any higher roles that may override.
    new_roles = old_roles.reject do |role|
      next unless role.id != member.role_id

      next unless member.roles.include?(role.id)

      old_roles.rindex(role.id) > (new_index || 0)
    end

    # Lastly, perform the API call the set the roles.
    data.user.set_roles(new_roles, "Event Roles")
  end
end
