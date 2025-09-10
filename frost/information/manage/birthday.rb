# frozen_string_literal: true

module Settings
  # Settings page for birthdays.
  def self.birthdays(data)
    # Request all of our guild data up front in order
    # to avoid making duplicate requested to the DB.
    guild = ::Birthdays::Guild.new(data)

    # Return unless birthday perks are enabled in this server.
    if guild.blank?
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
          section.text_display(text: format(RESPONSE[14], data.server.name))

          # Add the icon of the server as our thumbnail.
          section.thumbnail(url: data.server.icon_url)

          # Add the description text at the botton.
          section.text_display(text: RESPONSE[3])
        end

        # Add some spacing between the section content of our
        # container and the remaining content we're adding.
        container.seperator(divider: true, spacing: :small)

        # Add some spacing between the content of our container
        # and the footer text that we're adding.
        container.text_display(text: format(RESPONSE[8], guild.role))

        # Add the manager information we're now showing
        # and tracking. Includes the sanction timestamp.
        container.text_display(text: format(RESPONSE[6], *guild.view))

        # Guard against the channel being potentially deleted.
        if guild.channel && (data.bot.channel(guild.channel) rescue nil)
          # Add our footer text. Eventually this can be swapped out for
          # an action row with buttons for pagination if needed.
          container.text_display(text: format(RESPONSE[10], guild.channel))
        end
      end
    end
  end
end
