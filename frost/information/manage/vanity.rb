# frozen_string_literal: true

module Settings
  # Settings page for vanity roles.
  def self.vanity(data)
    # Request all of our guild data up front in order
    # to avoid making duplicate requested to the DB.
    guild = ::Roles::Guild.new(data)

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
          section.text_display(text: format(RESPONSE[19], data.server.name))

          # Add the icon of the server as our thumbnail.
          section.thumbnail(url: data.server.icon_url)

          # Add the description text at the botton.
          section.text_display(text: RESPONSE[3])
        end

        # Add some spacing between the section content of our
        # container and the remaining content we're adding.
        container.seperator(divider: true, spacing: :small)

        # Generate the text we're going to be showing to the user here.
        role = guild.role_id ? RESPONSE[6] % guild.role_id : nil

        # Add some spacing between the content of our container
        # and the footer text that we're adding.
        container.text_display(text: role || RESPONSE[5])

        # Add the manager information we're now showing
        # and tracking. Includes the sanction timestamp.
        container.text_display(text: format(RESPONSE[13], *guild.view)) if role
      end
    end
  end
end
