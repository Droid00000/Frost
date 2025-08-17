# frozen_string_literal: true

module AdminCommands
  # namespace for booster admins.
  module Boosters
    # Get a list of banned users in this server.
    def self.bans(data)
      unless data.user.permission?(:manage_roles)
        data.edit_response(content: RESPONSE[5])
        return
      end

      # Initialize the invoking guild.
      guild = ::Boosters::Guild.new(data, lazy: true)

      # Fetch the bans with offset here.
      bans = guild.bans(offset: data.options["offset"])

      # Return unless we have bans to show the user.
      if bans.empty?
        data.edit_response(content: RESPONSE[10])
        return
      end

      # Disable any user mentions.
      mentions = { allowed_mentions: { parse: [] } }

      # Manually enable the `IS_COMPONENTS_V2 (1 << 15)`
      # flags so we can use the new interaction components.
      data.send_message(**mentions, flags: 32_832) do |_, builder|
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
            section.text_display(text: RESPONSE[1])
          end

          # Add some spacing between the content of our container
          # and the select menu that we're conditionally adding.
          container.seperator(divider: true, spacing: :small)

          # Map all of our users into the format of index + mention.
          bans = bans.filter_map.with_index do |user, count|
            # Check for the existence of the user itself
            # since we don't want any failed role mentions.
            next unless data.bot.user(user[:user_id])

            "**#{count + 1}.** <@#{user[:user_id]}>"
          end

          # Create all of our actual ban content here.
          bans.take(16).map.with_index do |text, count|
            # Create the actual display container for the bans.
            container.text_display(text: text)

            # Add a seperator for some nice evenly spaced padding.
            unless (count + 1) == bans.take(16).size
              container.seperator(divider: false, spacing: :small)
            end
          end

          # Add some spacing between the content of our container
          # and the footer text that we're adding.
          container.seperator(divider: true, spacing: :small)

          # Add our footer text. Eventually this can be swapped out for
          # an action row with buttons for pagination if needed.
          container.text_display(text: format(RESPONSE[16], bans.take(16).size, bans.size))
        end
      end
    end
  end
end
