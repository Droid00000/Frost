# frozen_string_literal: true

module Frost::Overview
  # Event handler for the bot's settings menu.
  def self.owner_page(event)
    # EPHEMERAL and IS_COMPONENTS_V2 message flags.
    flags = (1 << 6) | (1 << 15)

    event.edit_response(flags: flags) do |_, ui|
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

        container.section do |section|
          section.text_display(content: "**Gateway**\n-# Events Seen: 1000\n-# Login Time: <t:#{Time.now.to_i}:d>\n")
          section.button(style: :danger, label: "Logout", custom_id: "owner_page_gateway_logout")
        end
      end
    end
  end
end
