# frozen_string_literal: true

module EventRoles
  # Interaction responses.
  REPLY = Frost::Utilities.table(
    MISSING_PERMISSIONS: "The bot is missing the `manage roles` permission.",
    GUILD_ROLE_NOT_FOUND: "The event role that you picked could not be found.",
    UNCONFIGURED_EVENT_ROLE: "The role that you picked is not an event role.",
    USER_NOT_FOUND_EVENT_ROLE: "You're not allowed to access this event role.",
    BOT_MAX_ROLE_BELOW_TARGET: "The bot's top role is below the selected event role.",
    MISSING_MEMBER_PERMISSIONS: "The bot does not have permission to interaction with you.",
    REMOVE_EVENT_ROLE_SUCCESSFUL: "Successfully removed the <@&%s> role.",
    APPPEND_EVENT_ROLE_SUCCESSFUL: "Successfully added the <@&%s> role.",
    USER_MISSING_CONFIGURE_PERMISSIONS: "You need to have the `manage roles` permission to do this.",
    USER_MAX_ROLE_BELOW_CONFIGURE_TARGET: "Your top role is below the selected event role.",
    ROLE_CONFIGURE_SUCCESSFUL: "Successfully configured the <@&%s> role.",
    EVENT_ROLE_DELETE_CONFIGURE_SUCCESS: "Successfully disabled the <@&%s> role."
  )

  # Make a specific role a user's highest event role.
  # @param member [Member] The member whose roles to modify.
  # @param event_role [Role] The event role to make the highest.
  # @param max_role [Role] The highest role that the current bot has.
  # @return [nil]
  def self.set_display_role(member, event_role, max_role)
    new_roles = member.roles.reject do |role|
      next false unless BOT.event_roles_cache.fetch_role(role)

      (role != event_role) && (role > event_role) && (role < max_role)
    end

    new_roles << event_role if new_roles.none?(event_role)

    member.modify(roles: new_roles, reason: "Event Roles")
  end
end
