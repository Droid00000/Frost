# frozen_string_literal: true

module Settings
  # A container with data about a guild's enabled functionality.
  def self.info(data)
    # Manually enable the `IS_COMPONENTS_V2 (1 << 15)`
    # flags so we can use the new interaction components.
    data.edit_response(new_components: true, flags: 64) do |_, builder|
      # Create a container in order to simulate the old look and
      # feel of an embed. This looks okay on mobile, but not so
      # good on desktop. I they make containers blend with themes.
      builder.container(colour: 10665982) do |container|
        # Add our main menu header here in a seperate text display
        # container in order to get some of that natural padding
        # that's tricky to stimulate with the other types of seperators.
        section.text_display(text: RESPONSE[6])

        # A lambda is defined here for building up a string containing
        # all of the stats and metrics about our bot, e.g. server count.
        stats = lambda do |data|
          guilds = data.bot.servers.values
          members = guilds.map(&:member_count).sum
          channels = [*guilds.map(&:channels)].size
          format(RESPONSE[3], guilds.size, members.delimit, channels)
        end

        # Create our main section body that contains all of the text we want
        # to show to our user. Currently, we have to use one big string, since
        # if we use multiple text displays, something kinda seems to look off.
        section.text_display(text: "#{RESPONSE[2]}#{RESPONSE[1]}#{stats.call(data)}")

        # Check if we're in a server, and if the user has the
        # manage roles permission in the server this command's called from.
        disabled = data.server_id && data.user.permission?(:manage_roles)

        # Add some spacing between the content of our container
        # and the select menu that we're going to show the user.
        container.seperator(divider: true, spacing: :small)

        # Add a select menu for the enabled features a server has.
        container.row do |row|
          row.select_menu(custom_id: "settings", placeholder: "Pick a category...", min_values: 1, disabled: !disabled) do |menu|
            menu.option(label: "Event Roles", value: "Events", description: "Settings for custom server roles.", emoji: "1281715509750005831")
            menu.option(label: "Birthdays", value: "Birthdays", description: "Settings for server birthdays.", emoji: "733787070123737109")
            menu.option(label: "Boosters", value: "Boosters", description: "Settings for server boosters.", emoji: "1320971944627146752")
            menu.option(label: "Pins", value: "Pins", description: "Settings for the pin archiver.", emoji: "1320929329307324497")
          end
        end
      end
    end
  end
end
