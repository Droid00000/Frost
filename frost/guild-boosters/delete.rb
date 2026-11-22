# frozen_string_literal: true

module Boosters
  # Delete a booster role.
  def self.booster_role_delete(event)
    unless event.user.premium_since
      event.edit_response(content: REPLY.MEMBER_MISSING_BOOST)
      return
    end

    unless event.guild.bot.can_manage_roles?
      event.edit_response(content: REPLY.BOT_MISSING_PERMISSIONS)
      return
    end

    unless (settings = BOT.boosters_cache.fetch_guild(event.guild_id))
      event.edit_response(content: REPLY.GUILD_UNCONFIGURED)
      return
    end

    if settings.banned?(event.user.id)
      event.edit_response(content: REPLY.MEMBER_BANNED_BOOSTER_PERKS)
      return
    end

    booster = settings.fetch_booster(event.user.id)

    if !booster || !(role = event.guild.role(booster.role_id))
      event.edit_response(content: REPLY.BOOSTER_ROLE_NOT_FOUND)
      return
    end

    if (booster.creation_time - Time.now).abs >= 300
      event.edit_response(content: REPLY.BOOSTER_ROLE_DELETE_COOLDOWN)
      return
    end

    begin
      role.delete(reason: "Booster Roles (ID: #{event.user.id})")
    rescue Discordrb::Errors::NoPermission
      event.edit_response(content: REPLY.BOOSTER_ROLE_DELETE_BOT_MAX_ROLE_BELOW)
      return
    end

    event.edit_response(content: REPLY.BOOSTER_ROLE_DELETE_SUCCESSFUL)

    # Perform the deletion asynchronously after we send a reply to the interaction.
    settings.delete_booster(id: event.user.id)
  end
end
