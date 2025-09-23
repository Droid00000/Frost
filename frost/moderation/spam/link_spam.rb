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
      make_bucket(key) && BUCKET[key.id].push(value.message, urls)
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
    def self.logger(key, value)
      # Create the descripton for the given view.
      description = lambda do |state|
        result = format(RESPONSE[3], value.deleted, key.id)
        state ? (result + format(RESPONSE[4], key.joined_at.to_i)) : result
      end

      unless member.timeout
        # Timeout the user if they've spammed in more than 10 channels.
        key.timeout = (Time.now + 604_800) if value.channel_count >= 10
      end

      # Wrap everything in a temporary directory.
      Dir.mktmpdir do |directory|
        # The path to the file to create.
        path = File.join(directory, "harmful-urls.txt")

        # Write the data to the file here, and then close it.
        File.open(path, "w") do |file|
          file.puts(value.links.map(&:to_s).join("\n\n"))
        end

        # Send the logging message here.
        BOT.channel(CONFIG[:Moderator][:CHANNEL]).send_embed("", [], [File.open(path, "rb")],
                                                             false, nil, nil, nil, 1 << 15) do |_, view|
          view.container do |container|
            container.section do |section|
              section.text_display(text: RESPONSE[7])
              section.thumbnail(url: key.display_avatar_url)
              section.text_display(text: description.call(key.respond_to?(:joined_at)))
            end

            # Only set the base name of the file here, not the whole path.
            container.file(url: "attachment://harmful-urls.txt")
          end
        end
      end
    end

    # Check if the given user is exempt from spam filtering.
    # @param user [#roles] the user or member to check for.
    # @return [true, false] whether the user is exempt.
    def self.exempt?(user)
      return true unless user.respond_to?(:roles)

      user.roles.map(&:id).intersect?(SAFE_ROLES)
    end

    # Fetch a user's storage bucket.
    # @param key [#id] the user or member whose storage bucket to fetch.
    # @return [StorageBucket, nil] the member's bucket, or `nil` for no bucket.
    def self.bucket(key)
      MUTEX.synchronize do
        return nil unless (bucket = BUCKET[key.id])

        bucket if bucket.full? || bucket.channel_count >= 3
      end
    end

    # Ensure a bucket exists for the given user.
    # @param user [#id] the user or member to create a bucket for.
    # @return [StorageBucket] the created storage bucket for the user.
    def self.make_bucket(user)
      MUTEX.synchronize { BUCKET[user.id] ||= StorageBucket.new }
    end

    # Remove any dead buckets. The removal threshold is one hour (3600s).
    # @return [void] this method does not return usable data for the caller.
    def self.audit_buckets
      MUTEX.synchronize { BUCKET.delete_if { |_, value| value.dead? } }
    end

    # Drain the provided storage bucket.
    # @param bucket [StorageBucket] the storage bucket which should be drained.
    # @return [Hash<Symbol => Integer, Array>] the results of the message deletion.
    def self.delete_spam(bucket)
      results = Hash.new { |map, key| map[key] = [] }

      MUTEX.synchronize do
        bucket.each do |item|
          results[:links].push(*item.uris)

          results[:deleted] << item if item.delete rescue nil
        end
      end

      results
    end

    # Merge multiple logging messages sent within a short time period into one.
    # @param user [#id] the user or member to create a logging bucket for.
    # @param value [Hash] the log data such as deleted message to log.
    def self.debounced_logger(user, value)
      MUTEX.synchronize do
        # Add the log message to the user's log stash.
        LOGGER[user.id] << value

        # If a debounce is already in progress, don't start another.
        LOGGER[user.id].bounced? ? return : LOGGER[user.id].bounced = true
      end

      # Remove the entry entirely, since the user usually gets banned.
      sleep(66) && MUTEX.synchronize { logger(user, LOGGER.delete(user.id)) }
    end
  end
end
