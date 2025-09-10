# frozen_string_literal: true

module Settings
  # A container with data about a guild's enabled functionality.
  def self.info(data)
    # Manually enable the `IS_COMPONENTS_V2 (1 << 15)`
    # flags so we can use the new interaction components.
    data.edit_response(has_components: true, flags: 64) do |_, builder|
      # Create a container in order to simulate the old look and
      # feel of an embed. This looks okay on mobile, but not so
      # good on desktop. I they make containers blend with themes.
      builder.container(colour: 10_665_982) do |container|
        # A lambda is defined here for building up a string containing
        # all of the stats and metrics about our bot, e.g. server count.
        stats = lambda do |context|
          guilds = context.bot.servers.values
          members = guilds.map(&:member_count).sum
          channels = guilds.flat_map(&:channels).size.delimit
          format(RESPONSE[11], guilds.size.delimit, members.delimit, channels)
        end

        # Add our main menu header here in a seperate text display
        # container in order to get some of that natural padding
        # that's tricky to stimulate with the other types of seperators.
        container.text_display(text: RESPONSE[16])

        # Create our main section body that contains all of the text we want
        # to show to our user. Currently, we have to use one big string, since
        # if we use multiple text displays, something kinda seems to look off.
        container.text_display(text: "#{RESPONSE[1]}#{stats.call(data)}")

        # Check if we're in a server, and if the user has the
        # manage roles permission in the server this command's called from.
        state = data.server_id && data.user.permission?(:manage_roles) rescue nil

        # Add some spacing between the content of our container
        # and the select menu that we're going to show the user.
        container.seperator(divider: true, spacing: :small)

        # Add a select menu for the enabled features a server has.
        container.row do |row|
          row.select_menu(custom_id: "settings", placeholder: "Pick a category...", min_values: 1, disabled: !state) do |menu|
            menu.option(label: "Birthdays", value: "Birthdays", description: "Settings for server birthdays.", emoji: "733787070123737109")
            menu.option(label: "Boosters", value: "Boosters", description: "Settings for server boosters.", emoji: "1320971944627146752")
          end
        end
      end
    end
  end
end
