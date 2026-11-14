# frozen_string_literal: true

module Boosters
  # Claim a booster role.
  def self.booster_role_claim(event)
    unless event.guild.bot.can_manage_roles?
      event.edit_response(content: REPLY.MISSING_PERMISSIONS)
      return
    end

    unless event.user.premium_since
      event.edit_response(content: REPLY.MEMBER_MISSING_BOOST)
      return
    end

    if event.guild.roles.length >= 250
      event.edit_response(content: REPLY.GUILD_MAX_ROLE_LIMIT)
      return
    end

    unless (settings = BOT.boosters_cache.fetch_guild(event.guild_id))
      event.edit_response(content: REPLY.UNCONFIGURED_GUILD)
      return
    end

    unless (hoist_role = event.guild.role(settings.role_id))
      event.edit_response(content: REPLY.GUILD_HOIST_ROLE_DELETED)
      return
    end

    if settings.banned?(event.user.id)
      event.edit_response(content: REPLY.MEMBER_BANNED_BOOSTER_PERKS)
      return
    end

    if invalid_role_name?(event.options[:name])
      event.edit_response(content: REPLY.BOOSTER_ROLE_NAME_DISALLOWED)
      return
    end

    if (booster = settings.fetch_booster(event.user.id))
      if event.guild.role(booster.role_id)
        event.edit_response(content: REPLY.BOOSTER_ROLE_ALREADY_CLAIMED)
        return
      else
        settings.delete_booster(booster.user_id, version: booster.version)
      end
    end

    payload = {
      name: event.options[:name],
      hoisted: false,
      color: extract_color(event.options[:color]),
      mentionable: false,
      display_icon: extract_icon(event, settings),
      permissions: "0"
    }

    x_audit_log = "Booster Roles (ID: #{event.user.id})"

    begin
      new_role = event.guild.create_role(**payload, reason: x_audit_log)
    rescue Discordrb::Errors::NoPermission
      event.edit_response(content: REPLY.MISSING_PERMISSIONS)
      return
    end

    begin
      new_role.move(above: hoist_role, reason: x_audit_log)
    rescue Discordrb::Errors::NoPermission
      new_role.delete(reason: "Booster Roles (Missing Permissions)")

      event.edit_response(content: REPLY.BOT_MAX_ROLE_BELOW_HOIST_ROLE)
      return
    end

    event.edit_response(content: REPLY.BOOSTER_ROLE_CLAIM_SUCCESSFUL)

    begin
      event.user.add_roles(new_role, reason: x_audit_log)
    rescue Discordrb::Errors::NoPermission
      event.edit_response(content: REPLY.MISSING_PERMISSIONS)
      return
    end

    begin
      settings.create_booster(
        role_id: new_role.id,
        user_id: event.user.id,
        version: event.interaction.id
      )
    rescue Sequel::UniqueConstraintViolation, Sequel::ForeignKeyConstraintViolation
      new_role.delete(reason: x_audit_log)
    end
  end
end
