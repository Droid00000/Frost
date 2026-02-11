# frozen_string_literal: true

module Moderation
  # Module for dealing with link spam.
  module FileSpam
    extend SpamFactory

    # Add a message to the user's storage bucket.
    # @param key [Discordrb::Member] the member whose bucket to increment.
    # @param value [Discordrb::Events::MessageEvent] the message data to store.
    def self.increment_bucket(key, value)
      # Don't do anything if we don't have enough files.
      return unless value.message.attachments.size > 2

      # Add the message data to the user's storage bucket.
      make_bucket(key).tap { it.push(value.message) }
    end

    # Send the logging message to the configured log channel.
    # @param user [#id] the user or member who was actioned against.
    # @param bucket [Loggable] the loggging stash to send to the channel.
    def self.logger(user, bucket)
      return if bucket.messages.empty?

      description = if user.respond_to?(:joined_at)
                      format(RESPONSE[3], bucket.messages.length, user.id, user.joined_at.to_i)
                    else
                      format(RESPONSE[3], bucket.messages.length, user.id)[..-6]
                    end

      channel = BOT.channel(CONFIG[:Moderator][:CHANNEL]) rescue nil

      io = StringIO.new(bucket.files.map(&:url).join("\n\n"), "rb")

      io.define_singleton_method(:path) { "attachment-urls.txt" }

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
            container_component.file(url: "attachment://attachment-urls.txt")
          end
        end
      end
    end
  end
end
