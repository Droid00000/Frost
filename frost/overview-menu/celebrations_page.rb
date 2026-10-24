# frozen_string_literal: true

module Frost::Overview
  # Event handler for the celebrations settings page.
  def self.celebrations_page(event)
    unless event.user.can_manage_roles?
      event.send_message(
        content: REPLY.MISSING_PERMISSIONS, ephemeral: true
      )

      return
    end

    settings = BOT.boosters_cache.fetch_guild(event.guild)

    unless settings
      event.send_message(
        content: REPLY.FEATURE_NOT_ENABLED, ephemeral: true
      )

      return
    end

    unless event.guild.role(settings.role_id)
      event.send_message(
        content: REPLY.CELEBRATIONS_ROLE_DELETED, ephemeral: true
      )

      return
    end

    # EPHEMERAL and IS_COMPONENTS_V2 message flags.
    flags = (1 << 6) | (1 << 15)

    event.send_message(flags: flags, **BOT.no_mentions) do |_, ui|
      # The entire response is wrapped in a container.
      ui.container do |container|
        container.section do |section|
          section.thumbnail(url: event.guild.icon_url)

          section.text_display(
            content: "### Birthday Perks for #{event.guild.name}\n"
          )

          section.text_display(content: ELEMENTS.CELEBRATIONS_MENU_OVERVIEW)
        end

        container.separator(spacing: :small, divider: true)

        container.text_display(
          content: format(ELEMENTS.CELEBRATIONS_MENU_ROLE_INFO, settings.role_id)
        )

        setup_at = settings.setup_at
        setup_by = event.bot.user(settings.setup_by)&.username

        container.text_display(
          content: format(ELEMENTS.CELEBRATIONS_MENU_MANAGER_INFO, setup_by, setup_at)
        )

        channel = event.bot.channel(settings.channel_id) if settings.channel_id

        if channel && event.user.can_view_channel?(channel)
          container.text_display(
            content: format(ELEMENTS.CELEBRATIONS_MENU_CHANNEL_INFO, settings.channel_id)
          )
        end
      end
    end
  end
end
