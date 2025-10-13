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
    # @param key [#id] the user or member who was actioned against.
    # @param value [Loggable] the loggging stash to send to the channel.
    def self.logger(key, value)
      # Don't do anything unless we have enough messages.
      return if value.messages.empty?

      # Create the descripton for the given view.
      description = lambda do |state|
        result = format(RESPONSE[3], value.messages.length, key.id)
        state ? (result + format(RESPONSE[4], key.joined_at.to_i)) : result
      end

      # Wrap everything in a temporary directory.
      Dir.mktmpdir do |directory|
        # The path to the file to create.
        path = File.join(directory, "attachment-urls.txt")

        # Write the data to the file here, and then close it.
        File.open(path, "w") do |file|
          file.puts(value.files.map(&:url).join("\n\n"))
        end

        # Send the logging message here.
        message = BOT.channel(CONFIG[:Moderator][:CHANNEL]).send_embed("", [], [File.open(path, "rb")],
                                                                       false, nil, nil, nil, 1 << 15) do |_, view|
          view.container do |container|
            container.section do |section|
              section.text_display(text: RESPONSE[6])
              section.thumbnail(url: key.display_avatar_url)
              section.text_display(text: description.call(key.respond_to?(:joined_at)))
            end

            # Only set the base name of the file here, not the whole path.
            container.file(url: "attachment://attachment-urls.txt")
          end
        end

        # Build out the database row here.
        # NOTE: We intentionally do not call #uniq on the file_counts field here.
        Storage.add({
                      guild_id: message.server.id,
                      alerted_at: message.id,
                      user_id: key.id,
                      spam_index: {
                        type: 0,
                        last_message: value.messages.last.id,
                        message_count: value.messages.length,
                        starter_message: value.messages[0].id,
                        threshold_message: value.messages[2].id,
                        hyperlinks: value.messages.flat_map(&:uris).uniq,
                        file_counts: value.messages.map { it.attachments.length }
                      }.to_json
                    })
      end
    end
  end
end
