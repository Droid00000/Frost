# frozen_string_literal: true

module General
  # An embed with data about a guild's enabled functionality.
  def self.info(data)
    data.edit_response(new_components: true) do |_, builder|
      # Create the main string with all the content we're planning on
      # sending to Discord in the response body. This is seperated by
      # newlines to achieve something that looks similar to embeds fields.
      section_body = "#{RESPONSE[1]}\n\n#{RESPONSE[1]}\n\n#{RESPONSE[1]}"

      # Create a container in order to simulate the old look and
      # feel of an embed. I'm hoping there's some improvements to
      # how this looks and feels on mobile, since it currently looks
      # like hot garbage. Looks great on the mobile clients though!
      builder.container do |container|
        # Create a section to contain all of our main content, since
        # if we attempt to only wrap our main heading text into a section
        # we get some very weird spacing due to the fact that the thumbnail
        # does not resize the spacing. This is a weird limitation that I hope
        # gets addressed sometime in the future. For now, this will do though.
        container.section do |section|
          section.text_display(text: HEADER[1])
          section.text_display(text: section_body)
          section.thumbnail(media: data.server.bot.avatar_url)
        end

        # container.text_display(text: "**About Me**\nI was made by droid00000. My code is open source and can be viewed here!")

        # container.text_display(text: "**Stats**\nI'm on 6 servers with a total of 62,344 members and 379 channels.")

        # Add some spacing between the content of our container
        # and the select menu that we're going to show the user.
        container.seperator(divider: true, spacing: :small)

        # Add a select menu for the enabled features a server has.
        # We should avoid adding the select menu and the divider
        # altogether if we don't have any enabled features in
        # the current server we're operating on.
        container.row do |row|
          row.select_menu(custom_id: "settings", placeholder: "Pick a category...", min_values: 1) do |menu|
            menu.option(label: "Event Roles", value: "Roles", description: "Settings for custom server roles.", emoji: 1_281_715_509_750_005_831)
            menu.option(label: "Birthdays", value: "Birthday", description: "Settings for server birthdays.", emoji: 733_787_070_123_737_109)
            menu.option(label: "Boosters", value: "Boosters", description: "Settings for server boosters.", emoji: 1_320_971_944_627_146_752)
            menu.option(label: "Pins", value: "Pins", description: "Settings for the pin archiver.", emoji: 1_320_929_329_307_324_497)
          end
        end
      end
    end
  end
end
