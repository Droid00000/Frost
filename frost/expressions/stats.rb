# frozen_string_literal: true

module Emojis
  # Stats related stuff.
  def self.cache(data)
    # Cache statistics for reactions.
    if data.emoji.id && !data.respond_to?(:emojis)
      Frost::Emojis.new(data.emoji, data.server)
      return
    end

    # Cache statistics for emojis.
    data.message.emoji.each do |emoji|
      Frost::Emojis.new(emoji, data.server)
    end
  end

  # Join a thread channel so we can track stats for it,
  # otherwise we won't reccive any message events, and
  # thus the stats we're collecting can easily become innacurate.
  def self.thread(data)
    data.channel.join if data.channel.thread?
  end

  def self.stats(data)
    # Return early unless we have emojis we can show the user
    # else there's no point in going any further with this command.
    unless Frost::Emojis.any?(data)
      data.edit_response(content: RESPONSE[1])
      return
    end

    # Fetch the top emojis from the database and resolve them all
    # into a hash of emoji objects, so we can map them up into our desired
    # format of: `<:mention:103030303030> - NAME **(INT)**`.
    emojis = Frost::Emojis.top(data).map do |emoji|
      next unless data.bot.emoji(emoji[:emoji_id])

      emoji = { key: data.bot.emoji(emoji[:emoji_id]), value: emoji[:balance] }

      "#{emoji[:key].mention} — #{emoji[:key].name} **(#{emoji[:value].delimit})**"
    end

    # The `new_components` argument must be manually set to true
    # to use V2 components. Enabling this disables the content and embeds fields.
    event.edit_response(new_components: true) do |_, builder|
      # Add a top level container here to container all of our other components.
      builder.container do |container|
        container.section do |section|
          section.text_display(text: format(RESPONSE[9], data.server.name))
          section.thumbnail(media: data.server.icon_url)
          section.text_display(text: RESPONSE[1])
        end

        # Set the color of the container to our bot's
        # default preferred role color. In the future
        # I want to allow server staff to pick any color,
        # but for now, this can only be determined by us.
        container.color = "#5c9aff"

        # Add a spacing between all of our descriptors and
        # titles, so we can put an emphasis on the main content.
        container.seperator(divider: true, spacing: :small)

        # Add our main body of text that we're hoping to present.
        # I'm hoping that discord allows a field like component to
        # allow for some degree of veritcal seperation, but I doubt
        # it's going to happen due to challenges with mobile devices.
        container.text_display(text: emojis.compact.join("\n"))

        # Add a fininshing bit of spacing between the main content
        # and the text we're attempting to emulate as a footer.
        container.seperator(divider: true, spacing: :small)

        # Add footer text showing how many emojis are being currently
        # displayed, and how many total emojis the bot has logged for
        # this server. Maybe we can replace this with a select menu one
        # day, allowing us to filter based on the usage type, e.g. reaction, message, etc.
        container.text_display(text: format(RESPONSE[7], emojis.size, Frost::Emojis.count(data)))
      end
    end
  end
end
