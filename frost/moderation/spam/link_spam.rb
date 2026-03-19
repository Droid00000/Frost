# frozen_string_literal: true

module Moderation
  # Module for dealing with link spam.
  module LinkSpam
    extend SpamFactory

    # Add a message to the user's storage bucket.
    # @param key [Discordrb::Member] the member whose bucket to increment.
    # @param value [Discordrb::Events::MessageEvent] the message data to store.
    def self.increment_bucket(key, value)
      # Don't do anything if we don't have enough links.
      return unless (urls = extract(value.message))

      # Add the message and the URL to the storage bucket.
      make_bucket(key).tap { it.push(value.message, urls) }
    end

    # Extract a set of URLs from a given string and convert them into {URI}.
    # @param value [String, #to_s] the string to parse and extract URLs from.
    # @Param parse [true, false] whether to return the parsed {URI} objects.
    # @return [Array<URI>] the URLs that were pared from the provided string.
    def self.extract(value)
      links = URI::RFC2396_PARSER.extract(value.to_s).map do |url|
        # Parse the URL, ignoring any errors.
        url = URI(url) rescue next

        # Sometimes the host part can be nil.
        next if url.host.nil?

        # Remove the www. part from the host.
        url.host = url.host.sub(/^www\./, "")

        # If we know the URL is safe, just skip it.
        next if SAFE_LINKS.include?(url.host)

        # Check for the emoji CDN sepcifically.
        next if (url.host == "cdn.discordapp.com") &&
                url.path.start_with?("/emojis")

        # Don't match any pointless URLs such as localhost.
        url if %w[http https].include?(url.scheme)
      end

      # only return the links if there are any.
      links.compact if links.any?
    end

    # Send the logging message to the configured log channel.
    # @param key [#id] the user or member who was actioned against.
    # @param value [Loggable] the loggging stash to send to the channel.
    def self.logger(user, bucket)
      return if bucket.messages.empty?

      description = if user.respond_to?(:joined_at)
                      format(RESPONSE[1], bucket.messages.length, user.id, user.joined_at.to_i)
                    else
                      format(RESPONSE[1], bucket.messages.length, user.id)[..-31]
                    end

      channel = BOT.channel(CONFIG[:Moderator][:CHANNEL]) rescue nil

      io = StringIO.new(bucket.links.map(&:to_s).join("\n\n"), "rb")

      io.define_singleton_method(:path) { "harmful-urls.txt" }

      channel&.send_message!(has_components: true, attachments: [io]) do |_, builder|
        # The container is the base entity that will contain all of our other components.
        builder.container do |container_component|
          # From here, a section will be added inside of the container to contain the content and avatar image.
          container_component.section do |section_component|
            # The first text display inside of the section is going to contain the type of spam that was actioned.
            section_component.text_display(content: RESPONSE[6])

            # The second text display inside of the section is going to contain metadata about the spam that was actioned.
            section_component.text_display(content: description)

            # The second to last thing we're going to add is the base/per-guild avatar of the member who created all of the spam.
            section_component.thumbnail(url: user.display_avatar_url)

            # Finally, all that's left for is to add is the file that contained all of the spam links or attachment URLs that were deleted.
            container_component.file(url: "attachment://harmful-urls.txt")
          end
        end
      end
    end
  end
end
