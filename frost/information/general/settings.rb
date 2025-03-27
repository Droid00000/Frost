# frozen_string_literal: true

module General
  # A container with data about a guild's enabled functionality.
  def self.info(data)
    # Manually enable the `IS_COMPONENTS_V2 (1 << 15)`
    # flags so we can use the new interaction components.
    data.edit_response(new_components: true, flags: 64) do |_, builder|
      # Create a container in order to simulate the old look and
      # feel of an embed. This looks okay on mobile, but not so
      # good on desktop.
      builder.container(colour: "#a2bffe") do |container|
        # Add our main menu header here in a seperate text display
        # container in order to get some of that natural padding
        # that's tricky to stimulate with the other types of seperators.
        section.text_display(text: RESPONSE[6])

        # Create our main section body that contains all of the text we want
        # to show to our user. Currently, we have to use one big string, since
        # if we use multiple text displays, something kinda seems to look off.
        section.text_display(text: "#{RESPONSE[2]}#{RESPONSE[1]}#{stats(data.bot)}")

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

  # A container with data about a guild's event roles.
  def self.events(data)
    # Return early unless we have roles we can show the user.
    # Else there's no point in going any further with this command.
    unless Frost::Roles.enabled?(data)
      data.send_message(content: RESPONSE[1])
      return
    end

    # Manually enable the `IS_COMPONENTS_V2 (1 << 15)`
    # flags so we can use the new interaction components.
    data.send_message(new_components: true, flags: 64) do |_, builder|
      # Create a container in order to simulate the old look and
      # feel of an embed. This looks okay on mobile, but not so
      # good on desktop.
      builder.container(colour: "#a2bffe") do |container|
        # Create a section to contain all of our main content, since
        # if we attempt to only wrap our main heading text into a section
        # we get some very weird spacing due to the fact that the thumbnail
        # does not resize the spacing. This is a weird limitation that I hope
        # gets addressed sometime in the future. For now, this will do though.
        container.section do |section|
          # Add our main title heading here.
          section.text_display do |display|
            display.text = format(RESPONSE[5], data.server.name)
          end

          # Add the icon of the server as our thumbnail.
          section.thumbnail(media: data.server.icon_url)

          # Add the description text at the botton.
          section.text_display(text: RESPONSE[1])
        end

        # Add some spacing between the content of our container
        # and the select menu that we're conditionally adding.
        container.seperator(divider: true, spacing: :small)

        # Add our main role content here. Take the first twenty
        # roles and join them all together by a newline character.
        container.text_display(text: Frost::Roles.all(data))

        # Add some spacing between the content of our container
        # and the footer text that we're adding.
        container.seperator(divider: true, spacing: :small)

        # Add our footer text. Eventually this can be swapped out for
        # an action row with buttons for pagination if needed.
        container.text_display(text: format(RESPONSE[5], roles.size, Frost::Roles.count(data)))
      end
    end
  end

  def self.boosters(data)
    # Return early unless booster perks are enabled in this server.
    unless Frost::Boosters::Settings.get(data)
      data.send_message(content: RESPONSE[1])
      return
    end

    # Manually enable the `IS_COMPONENTS_V2 (1 << 15)`
    # flags so we can use the new interaction components.
    data.send_message(new_components: true, flags: 64) do |_, builder|
      # Create a container in order to simulate the old look and
      # feel of an embed. This looks okay on mobile, but not so
      # good on desktop.
      builder.container do |container|
        # Create a section to contain all of our main content, since
        # if we attempt to only wrap our main heading text into a section
        # we get some very weird spacing due to the fact that the thumbnail
        # does not resize the spacing. This is a weird limitation that I hope
        # gets addressed sometime in the future. For now, this will do though.
        container.section do |section|
          # Add our main title heading here.
          section.text_display do |display|
            display.text = format(RESPONSE[5], data.server.name)
          end

          # Add the icon of the server as our thumbnail.
          section.thumbnail(media: data.server.icon_url)

          # Add the description text at the botton.
          section.text_display(text: RESPONSE[])
        end

        # Add some spacing between the section content of our
        # container and the remaining content we're adding.
        container.seperator(divider: true, spacing: :small)

        # Add our main role content here. Take the first twenty
        # roles and join them all together by a newline character.
        container.text_display(text: Frost::Roles.all(data))

        # Add some spacing between the content of our container
        # and the footer text that we're adding.
        container.text_display(text: format(RESPONSE[1], Frost::Boosters::Settings.get(data)))

        # Add the manager information we're now showing
        # and tracking. Includes the sanction timestamp.
        container.text_display(text: format(RESPONSE[1], Frost::Boosters::Settings.info(data)))

        # Add our footer text. Eventually this can be swapped out for
        # an action row with buttons for pagination if needed.
        container.text_display(text: format(RESPONSE[1], Frost::Boosters::Settings.icon(data)))
      end
    end
  end
end
