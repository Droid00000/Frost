# frozen_string_literal: true

module Frost::Overview
  # Event handler for the bot's owner menu.
  def self.owner_page(event)
    if event.user.id != BOT.config.owner_id
      event.send_message(content: REPLY.USER_NOT_BOT_OWNER, ephemeral: true)
      return
    end

    # EPHEMERAL and IS_COMPONENTS_V2 message flags.
    flags = (1 << 6) | (1 << 15)

    event.send_message(flags: flags) do |_, ui|
      # The entire response is wrapped in a container.
      ui.container do |container|
        container.text_display(content: "### Control Panel\n-# Welcome back Big Droid.")

        container.separator(spacing: :small, divider: true)

        container.section do |section|
          section.text_display(content: "**Restart**\n-# Restart the bot.")
          section.button(style: :primary, label: "Reboot", custom_id: "owner_page_restart")
        end

        container.separator(spacing: :small, divider: false)

        container.section do |section|
          section.text_display(content: "**Logging**\n-# View the bot's logfile.")
          section.button(style: :primary, label: "Viewer", custom_id: "owner_page_logging")
        end

        container.separator(spacing: :small, divider: false)

        container.section do |section|
          section.text_display(content: "**Evaluate**\n-# Run some Ruby code.")
          section.button(style: :primary, label: "Runner", custom_id: "owner_page_evaluate")
        end

        container.separator(spacing: :small, divider: true)

        events = Frost::Utilities.delimit(BOT.event_counter)

        container.section do |section|
          section.text_display(content: "**Gateway**\n-# Events Seen: #{events}\n-# Login Time: <t:#{BOT.ready_time}:d>\n")
          section.button(style: :danger, label: "Logout", custom_id: "owner_page_gateway_logout")
        end
      end
    end
  end

  # Event handler for the owner page's buttons.
  def self.owner_button(event)
    case event.custom_id
    when "owner_page_restart"
      owner_page_restart(event)
    when "owner_page_logging"
      owner_page_logging(event)
    when "owner_page_evaluate"
      owner_page_evaluate(event)
    end
  end

  # Event handler for the owner_page_logging button.
  def self.owner_page_logging(event)
    if event.user.id != BOT.config.owner_id
      event.send_message(
        content: REPLY.USER_NOT_BOT_OWNER, ephemeral: true
      )
      return
    end

    event.send_message(
      attachments: [File.open("logs.rb", "rb")], ephemeral: true
    )
  end
end
