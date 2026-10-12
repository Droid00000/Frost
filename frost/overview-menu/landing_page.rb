# frozen_string_literal: true

module Frost::Overview
  # Event handler for the info command.
  def self.landing_page(event)
    # EPHEMERAL and IS_COMPONENTS_V2 message flags.
    flags = (1 << 6) | (1 << 15)

    event.edit_response(flags: flags) do |_, ui|
      # The entire response is wrapped in a container.
      ui.container(color: 10_665_982) do |container|
        container.text_display(content: "### Main Menu")

        container.text_display(content: overview_text(event.bot))

        container.separator(divider: true, spacing: :small)

        owner = event.user.resolve_id == BOT.config.owner_id

        owner ? owner_menu(container, event) : basic_menu(container, event)
      end
    end
  end
end
