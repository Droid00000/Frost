# frozen_string_literal: true

module EventRoles
  # Configure an event role.
  def self.event_role_configure(event)
    unless event.user.can_manage_roles?
      event.edit_response(content: REPLY.USER_MISSING_CONFIGURE_PERMISSIONS)
      return
    end

    event.show_modal(title: "Event Roles", custom_id: "event_role_settings") do |ui|
      ui.label(label: "Role", description: "The role that you want to configure.") do |label|
        label.role_select(
          max_values: 1,
          required: true,
          custom_id: "event_role",
          placeholder: "Role Picker"
        )
      end

      ui.label(label: "Add Members", description: "The members that you want to link to the role.") do |label|
        label.user_select(
          max_values: 25,
          required: false,
          custom_id: "add_members",
          placeholder: "Member Picker"
        )
      end

      ui.label(label: "Remove Members", description: "The members that you want to un-link from the role.") do |label|
        label.user_select(
          max_values: 25,
          required: false,
          custom_id: "remove_members",
          placeholder: "Member Picker"
        )
      end
    end
  end

  # Update the configuration for an event role.
  def self.configure_submission(event)
    unless event.user.can_manage_roles?
      event.edit_response(content: REPLY.USER_MISSING_CONFIGURE_PERMISSIONS)
      return
    end

    id = event.get_component("event_role").values[0]

    unless (guild_role = event.guild.role(id))
      event.edit_response(content: REPLY.GUILD_ROLE_NOT_FOUND)
      return
    end

    if guild_role > event.user.highest_role
      event.edit_response(content: REPLY.USER_MAX_ROLE_BELOW_CONFIGURE_TARGET)
      return
    end

    unless (event_role = BOT.event_roles_cache.fetch_role(id))
      event_role = BOT.event_roles_cache.create_role(id: id, guild: event.guild)
    end

    event.edit_response(
      **BOT.no_mentions,
      content: format(REPLY.ROLE_CONFIGURE_SUCCESSFUL, id)
    )

    event_role&.modify_users(
      add: event.get_component("add_members")&.values,
      remove: event.get_component("remove_members")&.values
    )
  end

  # Delete an event role.
  def self.event_role_disable(event)
    unless event.user.can_manage_roles?
      event.edit_response(content: REPLY.USER_MISSING_CONFIGURE_PERMISSIONS)
      return
    end

    id = event.options[:role].to_i

    unless (guild_role = event.guild.role(id))
      event.edit_response(content: REPLY.GUILD_ROLE_NOT_FOUND)
      return
    end

    if guild_role > event.user.highest_role
      event.edit_response(content: REPLY.USER_MAX_ROLE_BELOW_CONFIGURE_TARGET)
      return
    end

    event.edit_response(
      **BOT.no_mentions,
      content: format(REPLY.EVENT_ROLE_DELETE_CONFIGURE_SUCCESS, id)
    )

    BOT.event_roles_cache.delete_role(id)
  end
end
