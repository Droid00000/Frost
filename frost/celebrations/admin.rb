# frozen_string_literal: true

module Celebrations
  # Configure the celebrations feature.
  def self.birthday_admin_configure(event)
    unless event.user.can_administrate?
      event.edit_response(content: REPLY.USER_MISSING_CONFIGURE_PERMISSIONS)
      return
    end

    settings = BOT.birthdays_cache.fetch_guild(event.guild_id)
    role_default = settings && event.guild.role(settings.role_id) ? [settings.role_id] : nil
    channel_default = settings && event.bot.channel(settings.channel_id) ? [settings.channel_id] : nil

    event.show_modal(title: "Settings", custom_id: "birthday_settings") do |modal|
      modal.label(label: "Birthday Role", description: "The role members should be given on their birthday.") do |label|
        label.role_select(
          max_values: 1,
          required: true,
          custom_id: "role_picker",
          default_values: role_default
        )
      end

      modal.label(label: "Announcement Channel", description: "The channel where birthday annoucements should be sent.") do |label|
        label.channel_select(
          max_values: 1,
          required: false,
          custom_id: "channel_picker",
          default_values: channel_default,
          types: %i[
            text
            announcement
            public_thread
            announcement_thread
          ]
        )
      end
    end
  end

  # Update the configuration for a guild.
  def self.configure_submission(event)
    unless event.user.can_administrate?
      event.edit_response(content: REPLY.USER_MISSING_CONFIGURE_PERMISSIONS)
      return
    end

    roles = event.get_component("role_picker")
    channels = event.get_component("channel_picker")
    selected_role = event.guild.role(roles.values.first)

    if selected_role && selected_role > event.user.top_role
      event.edit_response(content: REPLY.USER_MAX_ROLE_BELOW_CONFIGURE_TARGET)
      return
    end

    if selected_role.id == event.guild_id
      event.edit_response(content: REPLY.INVALID_CONFIGURE_TARGET_EVERYONE_ROLE)
      return
    end

    if guild_role.managed? || guild_role.bot_id ||
       guild_role.integration_id || guild_role.connections? ||
       guild_role.premium_subscriber? || guild_role.available_for_purchase?
      event.edit_response(content: REPLY.INVALID_CONFIGURE_TARGET_MANAGED_ROLE)
      return
    end

    BOT.birthdays_cache.create_guild(
      id: event.guild_id,
      role: selected_role,
      setup_by: event.user,
      channel: channels.values.first
    )

    event.edit_response(content: REPLY.CONFIGURE_SUCCESS)
  end

  # Delete an event role.
  def self.birthday_admin_disable(event)
    unless event.user.can_administrate?
      event.edit_response(content: REPLY.USER_MISSING_CONFIGURE_PERMISSIONS)
      return
    end

    result = BOT.birthdays_cache.delete_guild(event.guild_id)

    if result.nil?
      event.edit_response(content: DELETE_CONFIGURE_SUCCESS)
    else
      event.edit_response(content: GUILD_UNCONFIGURED)
    end
  end
end
