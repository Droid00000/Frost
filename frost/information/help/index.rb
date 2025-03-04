# frozen_string_literal: true

def help_index(data)
  data.send_message do |builder, components|
    builder.add_embed do |embed|
      embed.colour = UI[6]
      embed.title = EMBED[68]
      embed.timestamp = Time.now
      embed.description = EMBED[69]
      embed.add_field(name: EMBED[70], value: EMBED[71])
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
      embed.add_field(name: EMBED[196], value: format(EMBED[197], data.bot.count_servers, data.bot.count_members, data.bot.count_channels))
    end
  end
end

module Help
  # An embed with data about a guild's enabled functionality.
  def self.index(data)
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
          row.select_menu(custom_id: EMBED[126], placeholder: EMBED[1], min_values: 1) do |menu|
            menu.option(label: EMBED[1], value: EMBED[1], description: EMBED[1], emoji: 1281715509750005831)
            menu.option(label: EMBED[1], value: EMBED[1], description: EMBED[1], emoji: 1281715509750005831)
            menu.option(label: EMBED[1], value: EMBED[1], description: EMBED[1], emoji: 1281715509750005831)
            menu.option(label: EMBED[1], value: EMBED[1], description: EMBED[1], emoji: 1281715509750005831)
            menu.option(label: EMBED[1], value: EMBED[1], description: EMBED[1], emoji: 1281715509750005831)
          end
        end
      end
    end
  end
end
