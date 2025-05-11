# frozen_string_literal: true

module Emojis
  # Stats related stuff.
  def self.cache(data)
    # Cache statistics for reactions.
    if !data.respond_to?(:file) && data.emoji.id
      Storage.add(data.emoji, data.server)
      return
    end

    # Cache statistics for messages.
    data.message.emoji.each do |emoji|
      Storage.add(emoji, data.server)
    end
  end

  # A view with information about the most used emojis.
  def self.stats(data)
    # Request all of our emojis only once. This saves us from
    # having to make multiple round-trips to the database.
    emojis = Storage.top(data)

    # Since someone's trying to view the stats, we should run an
    # audit job here in order to update results on demand.
    Thread.new { Storage.large? }

    # Fetch the top emojis from the database and resolve them all
    # into a hash of emoji objects, so we can map them into our desired format.
    emojis = emojis.filter_map do |emoji|
      next unless data.server.emojis.key?(emoji[:emoji_id])

      emoji = [data.bot.emoji(emoji[:emoji_id]), emoji[:balance].delimit]

      "#{emoji.first.mention} — #{emoji.first.name} **(#{emoji.last})**\n"
    end

    # Check if there are local emojis that aren't indexed.
    if Storage.index?(data.server.id) && emojis.empty?
      [data.edit_response(content: RESPONSE[4]), Storage.drain]
      return
    end

    # Return early unless we have emojis we can show.
    unless emojis.any?
      data.edit_response(content: RESPONSE[3])
      return
    end

    # Manually enable the `IS_COMPONENTS_V2 (1 << 15)`
    # flags so we can use the new interaction components.
    data.edit_response(has_components: true) do |_, builder|
      # Add a top level container here to container all of our other components.
      builder.container do |container|
        # Add a section (mainly so we can add a thumbnail).
        container.section do |section|
          # Add our main title heading here.
          section.text_display(text: format(RESPONSE[9], data.server.name))

          # Add the icon of the server as our thumbnail.
          section.thumbnail(media: data.server.icon_url)

          # Add the description text at the botton.
          section.text_display(text: RESPONSE[1])
        end

        # Add a spacing between all of our descriptors and
        # titles, so we can put an emphasis on the main content.
        container.seperator(divider: true, spacing: :small)

        # Add our main body of text that we're hoping to present.
        # I'm hoping that discord allows a field like component to
        # allow for some degree of veritcal seperation, but I doubt
        # it's going to happen due to challenges with mobile devices.
        container.text_display(text: emojis.first(17).join)

        # Add a fininshing bit of spacing between the main content
        # and the text we're attempting to emulate as a footer.
        container.seperator(divider: true, spacing: :small)

        # Add footer text showing how many emojis are being currently
        # displayed, and how many total emojis the bot has logged for
        # this server. Maybe we can replace this with a select menu one day.
        container.text_display(text: RESPONSE[6])
      end
    end
  end
end
