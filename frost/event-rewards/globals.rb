# frozen_string_literal: true

module EventRoles
  # Interaction responses.
  REPLY = Frost::Utilities.table(
    MISSING_PERMISSIONS: "The bot is missing the `manage roles` permission.",
    GUILD_ROLE_NOT_FOUND: "The event role that you picked could not be found.",
    UNCONFIGURED_EVENT_ROLE: "The role that you picked is not an event role.",
    USER_NOT_FOUND_EVENT_ROLE: "You're not allowed to access this event role.",
    BOT_MAX_ROLE_BELOW_TARGET: "The bot's top role is below the selected event role.",
    MISSING_MEMBER_PERMISSIONS: "The bot does not have permission to interaction with you.",
    REMOVE_EVENT_ROLE_SUCCESSFUL: "Successfully removed the <@&%s> role.",
    APPPEND_EVENT_ROLE_SUCCESSFUL: "Successfully added the <@&%s> role.",
    USER_MISSING_CONFIGURE_PERMISSIONS: "You need to have the `manage roles` permission to do this.",
    USER_MAX_ROLE_BELOW_CONFIGURE_TARGET: "Your top role is below the selected event role.",
    ROLE_CONFIGURE_SUCCESSFUL: "Successfully configured the <@&%s> role.",
    EVENT_ROLE_DELETE_CONFIGURE_SUCCESS: "Successfully disabled the <@&%s> role.",
    INVALID_CONFIGURE_TARGET_EVERYONE_ROLE: "The `@everyone` role cannot be an event role.",
    INVALID_CONFIGURE_TARGET_MANAGED_ROLE: "A role managed by an integration cannot be an event role.",
    NO_EVENT_ROLES_AVAILABLE: "You don't have any event roles."
  )

  # Font widths of characters.
  GG_SANS_WIDTHS = {
    "0" => 9.343994140625,
    "1" => 5.6959991455078125,
    "2" => 8.303985595703125,
    "3" => 8.735992431640625,
    "4" => 8.89599609375,
    "5" => 8.57598876953125,
    "6" => 8.55999755859375,
    "7" => 7.3279876708984375,
    "8" => 8.447998046875,
    "9" => 8.55999755859375,
    "a" => 8.143997192382812,
    "b" => 8.847991943359375,
    "c" => 8.063995361328125,
    "d" => 8.847991943359375,
    "e" => 8.11199951171875,
    "f" => 5.391998291015625,
    "g" => 8.047988891601562,
    "h" => 8.607986450195312,
    "i" => 3.6479949951171875,
    "j" => 3.6479949951171875,
    "k" => 7.8079986572265625,
    "l" => 4.0479888916015625,
    "m" => 12.991989135742188,
    "n" => 8.447998046875,
    "o" => 8.479995727539062,
    "p" => 8.847991943359375,
    "q" => 8.847991943359375,
    "r" => 6.0319976806640625,
    "s" => 7.23199462890625,
    "t" => 6.12799072265625,
    "u" => 8.447998046875,
    "v" => 7.5519866943359375,
    "w" => 11.23199462890625,
    "x" => 7.3279876708984375,
    "y" => 7.519989013671875,
    "z" => 7.00799560546875,
    "A" => 10.303985595703125,
    "B" => 9.7919921875,
    "C" => 10.175994873046875,
    "D" => 10.527999877929688,
    "E" => 8.959991455078125,
    "F" => 8.719985961914062,
    "G" => 10.719985961914062,
    "H" => 10.719985961914062,
    "I" => 3.8719940185546875,
    "J" => 8.207992553710938,
    "K" => 9.67999267578125,
    "L" => 8.89599609375,
    "M" => 13.407989501953125,
    "N" => 10.89599609375,
    "O" => 10.944000244140625,
    "P" => 9.711990356445312,
    "Q" => 10.944000244140625,
    "R" => 9.967987060546875,
    "S" => 8.89599609375,
    "T" => 8.511993408203125,
    "U" => 10.68798828125,
    "V" => 9.631988525390625,
    "W" => 13.055999755859375,
    "X" => 9.407989501953125,
    "Y" => 9.439987182617188,
    "Z" => 8.815994262695312,
    " " => 3.519989013671875,
    "-" => 6.5279998779296875,
    "_" => 8.12799072265625,
    "." => 3.8719940185546875,
    "," => 3.8719940185546875,
    " =>" => 3.8719940185546875,
    "!" => 3.743988037109375,
    "?" => 7.631988525390625,
    "'" => 2.847991943359375
  }.freeze

  # Add the UI used to display roles in the locker.
  # @param view [View] The components view to add the roles to.
  # @param guild_roles [Array<Role>] The roles to add to the UI.
  # @param member [Member] The member to build the role locker for.
  def self.add_roles_ui(view, guild_roles, member)
    value = nil

    view.container do |container|
      container.text_display(content: "### Event Roles")

      container.separator(divider: true, spacing: :small)

      guild_roles.each_with_index do |role, index|
        next unless (event_role = BOT.event_roles_cache.fetch_role(role))

        container.section do |section|
          state = member.role?(role)
          count = Frost::Utilities.delimit(event_role.user_count)

          section.button(
            label: state ? "Remove" : "Equip",
            custom_id: "event_role_#{role.id}",
            style: state ? :danger : :secondary
          )

          section.text_display(
            content: "-# #{role.mention}\n-# Approximate Users: **#{count}**"
          )

          add_divider = (index + 1) <= guild_roles.length

          container.separator(divider: false, spacing: :small) if add_divider
        end
      end

      container.separator(divider: true, spacing: :small).tap { value = container }
    end

    value
  end
end
