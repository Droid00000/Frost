# frozen_string_literal: true

module Moderation
  # Configure the robomod filter.
  def self.robomod_configure(event)
    unless event.user.can_administrate?
      event.edit_response(content: REPLY.USER_MISSING_CONFIGURE_PERMISSIONS)
      return
    end

    if (settings = BOT.moderation_cache.fetch_guild(event.guild_id))
      exempt_roles_default = settings.exempt_roles.select { event.guild.role(it) }
      timeout_seconds_default = format_duration_seconds(settings.timeout_duration)
      exempt_channels_default = settings.exempt_channels.select { event.bot.channel(it) }
      alert_channel_default = event.bot.channel(settings.channel_id) ? [settings.channel_id] : nil
    end

    event.show_modal(title: "Settings", custom_id: "automod_settings") do |modal|
      modal.label(label: "Alert Channel", description: "The channel where spam alerts should be sent.") do |label|
        label.channel_select(
          max_values: 1,
          required: true,
          default_values: alert_channel_default,
          custom_id: "alert_channel_#{alert_channel_default&.first || -1}",
          types: %i[
            text
            announcement
            public_thread
            private_thread
            announcement_thread
          ]
        )
      end

      modal.label(label: "Exempt Roles", description: "The roles that should be exempt from the filter.") do |label|
        label.role_select(
          max_values: 25,
          required: false,
          default_values: exempt_roles_default,
          custom_id: "exempt_roles_#{event.interaction.id}"
        )
      end

      modal.label(label: "Exempt Channels", description: "The channels that should be exempt from the filter.") do |label|
        label.channel_select(
          max_values: 25,
          required: false,
          default_values: exempt_channels_default,
          custom_id: "exempt_channels_#{event.interaction.id}",
          types: %i[
            text
            voice
            stage
            announcement
            public_thread
            private_thread
            announcement_thread
          ]
        )
      end

      modal.label(label: "Timeout Duration", description: "The timeout duration for members who trigger the filter.") do |label|
        label.text_input(
          style: :short,
          max_length: 30,
          required: false,
          default_value: timeout_seconds_default,
          placeholder: "E.g. 5 minutes, 1 hour, 25 days, etc.",
          custom_id: "timeout_duration_#{settings&.timeout_duration || -1}"
        )
      end
    end
  end
end
