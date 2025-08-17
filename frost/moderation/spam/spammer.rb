# frozen_string_literal: true

module Moderation
  # Check for attachment spam specifically.
  def self.spam(data)
    # Only check for spam in the configured mod server.
    return if data.server.id != CONFIG[:Moderator][:GUILD]

    # Return if the user has only role that's exempt.
    return if FileSpam.exempt?(data.user)

    # Increment the user's anti-spam bucket if we can.
    FileSpam.increment_bucket(data.user, data)

    # This will only return the bucket if there are enough items.
    return unless (bucket = FileSpam.bucket(data.user))

    # Iterate through the entire bucket. The result is the data we need.
    resulting_delete_value = FileSpam.delete_spam(bucket)

    # We might have other threads that are going to delete more spam, so
    #   we don't want to send the same log message multiple times when we can batch it.
    FileSpam.debounced_logger(data.user, resulting_delete_value)
  end

  # Check for link/HTTP URL spam specifically.
  def self.link(data)
    # Only check for spam in the configured mod server.
    return if data.server.id != CONFIG[:Moderator][:GUILD]

    # Return if the user has only role that's exempt.
    return if LinkSpam.exempt?(data.user)

    # Increment the user's anti-spam bucket if we can.
    LinkSpam.increment_bucket(data.user, data)

    # This will only return the bucket if there are enough items.
    return unless (bucket = LinkSpam.bucket(data.user))

    # Iterate through the entire bucket. The result is the data we need.
    resulting_delete_value = LinkSpam.delete_spam(bucket)

    # We might have other threads that are going to delete more spam, so
    #   we don't want to send the same log message multiple times when we can batch it.
    LinkSpam.debounced_logger(data.user, resulting_delete_value)
  end
end
