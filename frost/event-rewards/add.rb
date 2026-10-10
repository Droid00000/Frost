# frozen_string_literal: true

module EventRoles
  # Add an event role to a user.
  def self.add_event_role(event)
    unless event.guild.current_bot.can_manage_roles?
      event.edit_response(content: REPLY.MISSING_PERMISSIONS)
      return
    end

    id = event.options[:role].to_i

    unless (guild_role = event.guild.role(id))
      event.edit_response(content: REPLY.GUILD_ROLE_NOT_FOUND)
      return
    end

    unless (event_role = BOT.event_roles_cache.fetch_role(id))
      event.edit_response(content: REPLY.UNCONFIGURED_EVENT_ROLE)
      return
    end

    unless event_role.user?(event.user.id)
      event.edit_response(content: REPLY.USER_NOT_FOUND_EVENT_ROLE)
      return
    end

    bot_max_role = event.guild.current_bot.highest_role

    if bot_max_role < guild_role
      event.edit_response(content: REPLY.BOT_MAX_ROLE_BELOW_TARGET)
      return
    end

    begin
      if event.options[:display]
        set_display_role(event.user, guild_role, bot_max_role)
      elsif event.user.roles.none?(id)
        event.user.add_role(id, atomic: true, reason: "Event Roles")
      end
    rescue Discordrb::Errors::NoPermission
      event.edit_response(content: REPLY.MISSING_MEMBER_PERMISSIONS)
      return
    end

    event.edit_response(
      **BOT.no_mentions, content: format(REPLY.APPPEND_EVENT_ROLE_SUCCESSFUL, id)
    )
  end
end
