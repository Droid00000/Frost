# frozen_string_literal: true

module Settings
  # A container with data about a guild's event roles.
  def self.events(data)
    # Initailize the guild we're operating on.
    roles = POSTGRES[:event_settings].where(guild_id: data.server.id)

    # Return early unless we have roles we can show the user.
    # Else there's no point in going any further with this command.
    if roles.empty?(data)
      data.send_message(content: RESPONSE[1])
      return
    end

    # Manually enable the `IS_COMPONENTS_V2 (1 << 15)`
    # flags so we can use the new interaction components.
    data.send_message(has_components: true, flags: 64) do |_, builder|
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
          section.text_display(text: format(RESPONSE[5], data.server.name))

          # Add the icon of the server as our thumbnail.
          section.thumbnail(media: data.server.icon_url)

          # Add the description text at the botton.
          section.text_display(text: RESPONSE[1])
        end

        # Map all of our roles into the format of index + mention.
        roles = roles.map.index do |role, count|
          "**#{count + 1}.** <@&#{role[:role_id]}>\n"
        end

        # Add some spacing between the content of our container
        # and the select menu that we're conditionally adding.
        container.seperator(divider: true, spacing: :small)

        # Add our main role content here. Take the first twenty
        # roles and join them all together by a newline character.
        container.text_display(text: roles.take(50).join)

        # Add some spacing between the content of our container
        # and the footer text that we're adding.
        container.seperator(divider: true, spacing: :small)

        # Add our footer text. Eventually this can be swapped out for
        # an action row with buttons for pagination if needed.
        container.text_display(text: format(RESPONSE[5], roles.take(50).size, roles.size))
      end
    end
  end
end
