# frozen_string_literal: true

module Settings
  # A container with data about a guild's event roles.
  def self.events(data)
    # Initailize the guild we're operating on.
    roles = POSTGRES[:event_settings].where(guild_id: data.server.id)

    # Return early unless we have roles we can show the user.
    # Else there's no point in going any further with this command.
    if roles.empty?
      data.send_message(content: RESPONSE[13], ephemeral: true)
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
          section.text_display(text: format(RESPONSE[17], data.server.name))

          # Add the icon of the server as our thumbnail.
          section.thumbnail(url: data.server.icon_url)

          # Add the description text at the botton.
          section.text_display(text: RESPONSE[3])
        end

        # Add some spacing between the content of our container
        # and the select menu that we're conditionally adding.
        container.seperator(divider: true, spacing: :small)

        # Map all of our roles into the format of index + mention.
        roles = roles.filter_map.with_index do |role, count|
          # Check for the existence of the role itself
          # since we don't want any failed role mentions.
          next unless data.server.role(role[:role_id])

          "**#{count + 1}.** <@&#{role[:role_id]}>"
        end

        # Create all of our actual role content here.
        roles.take(16).map.with_index do |text, count|
          # Create the actual display container for the role.
          container.text_display(text: text)

          # Add a seperator for some nice evenly spaced padding.
          unless (count + 1) == roles.take(16).size
            container.seperator(divider: false, spacing: :small)
          end
        end

        # Add some spacing between the content of our container
        # and the footer text that we're adding.
        container.seperator(divider: true, spacing: :small)

        # Add our footer text. Eventually this can be swapped out for
        # an action row with buttons for pagination if needed.
        container.text_display(text: format(RESPONSE[14], roles.take(16).size, roles.size))
      end
    end
  end
end
