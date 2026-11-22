# frozen_string_literal: true

module Boosters
  # Edit a booster role.
  def self.booster_role_edit(event)
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

    if invalid_role_name?(event.options[:name])
      event.edit_response(content: REPLY.BOOSTER_ROLE_NAME_DISALLOWED)
      return
    end

    payload = {
      name: event.options[:name],
      color: extract_color(event.options[:color]),
      display_icon: extract_icon(event, settings)
    }.compact

    if payload[:color]
      payload[:tertiary_color] = nil
      payload[:secondary_color] = nil
    end

    unless payload[:display_icon]
      # rubocop:disable Style/SoleNestedConditional
      if event.options[:icon]&.match?(RESET_ROLE_FIELD_REGEX)
        payload[:icon] = nil
        payload[:unicode_emoji] = nil
      end
    end

    unless payload[:color]
      if event.options[:color]&.match?(RESET_ROLE_FIELD_REGEX)
        payload[:color] = nil
        payload[:tertiary_color] = nil
        payload[:secondary_color] = nil
      end
    end

    # rubocop:enable Style/SoleNestedConditional
    if payload.empty?
      event.edit_response(content: REPLY.BOOSTER_ROLE_EDIT_SUCCESSFUL)
      return
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
