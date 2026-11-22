# frozen_string_literal: true

module Boosters
  # Edit a booster role's gradient.
  def self.booster_role_gradient(event)
    unless event.user.premium_since
      event.edit_response(content: REPLY.MEMBER_MISSING_BOOST)
      return
    end

    unless event.guild_features.include?(:ENHANCED_ROLE_COLORS)
      event.edit_response(content: REPLY.GUILD_MISSING_ENHANCED_ROLE_COLORS)
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

    if settings.no_gradient?
      event.edit_response(content: REPLY.GRADIENT_ROLES_DISABLED)
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

    start = event.options[:start]
    secondary = event.options[:end]

    payload = {
      color: extract_color(start),
      secondary_color: extract_color(secondary)
    }.compact

    if event.options[:holographic] && !start && !secondary
      payload = {
        color: 11_127_295,
        tertiary_color: 16_761_760,
        secondary_color: 16_759_788
      }
    elsif role.secondary_color || role.tertiary_color
      if payload.empty? && role.secondary_color && !role.tertiary_color
        event.edit_response(content: REPLY.MISSING_START_AND_END_COLORS)
        return
      elsif payload.empty?
        event.edit_response(content: REPLY.MISSING_START_OR_END_COLORS)
        return
      elsif !payload[:color] && start
        event.edit_response(content: REPLY.INVALID_START_COLOR)
        return
      elsif !payload[:secondary_color] && secondary
        event.edit_response(content: REPLY.INVALID_END_COLOR)
        return
      elsif !payload[:color]
        event.edit_response(content: REPLY.MISSING_START_COLOR)
        return
      elsif !payload[:secondary_color]
        event.edit_response(content: REPLY.MISSING_END_COLOR)
        return
      end

      payload[:tertiary_color] = nil
    end

    begin
      role.modify(**payload, reason: "Booster Roles (ID: #{event.user.id})")
    rescue Discordrb::Errors::NoPermission
      event.edit_response(content: REPLY.BOOSTER_ROLE_EDIT_BOT_MAX_ROLE_BELOW)
      return
    end

    event.edit_response(content: REPLY.BOOSTER_ROLE_EDIT_SUCCESSFUL)
  end
end
