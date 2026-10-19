# frozen_string_literal: true

module EventRoles
  # Add or remove an event role.
  def self.handle_locker_button(event)
    unless event.guild.current_bot.can_manage_roles?
      event.send_message(content: REPLY.MISSING_PERMISSIONS, ephemeral: true)
      return
    end

    id = event.custom_id.split("_").last.to_i

    unless (guild_role = event.guild.role(id))
      event.send_message(content: REPLY.GUILD_ROLE_NOT_FOUND, ephemeral: true)
      return
    end

    unless (event_role = BOT.event_roles_cache.fetch_role(id))
      event.send_message(content: REPLY.UNCONFIGURED_EVENT_ROLE, ephemeral: true)
      return
    end

    unless event_role.user?(event.user.id)
      event.send_message(content: REPLY.USER_NOT_FOUND_EVENT_ROLE, ephemeral: true)
      return
    end

    bot_max_role = event.guild.current_bot.highest_role

    if bot_max_role < guild_role
      event.send_message(content: REPLY.BOT_MAX_ROLE_BELOW_TARGET, ephemeral: true)
      return
    end

    has_role = event.user.role?(id)

    begin
      if has_role
        event.user.remove_role(id, atomic: true, reason: "Event Roles")
      else
        event.user.add_role(id, atomic: true, reason: "Event Roles")
      end
    rescue Discordrb::Errors::NoPermission
      event.send_message(content: REPLY.MISSING_MEMBER_PERMISSIONS, ephemeral: true)
      return
    end

    ui = event.interaction.components_tree

    # has_role means the opposite after the action.
    ui.modify_button(
      event.custom_id.to_s,
      label: has_role ? "Equip" : "Remove",
      style: has_role ? :secondary : :danger
    )

    # EPHEMERAL and IS_COMPONENTS_V2 message flags.
    flags = (1 << 6) | (1 << 15)

    event.edit_response(components: ui, flags: flags)
  end
end
