# frozen_string_literal: true

module Moderation
  # Check for attachment spam specifically.
  def self.spam(data)
    # Only check for spam in the configured mod server.
    return if data.server != CONFIG[:Moderation][:GUILD]

    # Return if the user has only role that's exempt.
    return if FileSpam.exempt?(data.user)

    # Increment the user's anti-spam bucket if we can.
    FileSpam.increment_bucket(data.user, data)

    # This will only return the bucket if there are enough items.
    return unless (bucket = FileSpam.bucket(data.user))

    # Iterate through the entire bucket. The result is the data we need.
    resulting_delete_value = FileSpam.delete_spam(bucket)

    # Sometimes, due to how quick we delete spam messages, we can end up
    #   with un-deleted messages, so we have to set a "last deleted at timestamp".
    FileSpam.last_actioned_at(data.user, resulting_delete_value[:time])

    # We might have other threads that are going to delete more spam, so
    #   we don't want to send the same log message multiple times when we can batch it.
    FileSpam.debounce_logging_messages(data.user, resulting_delete_value)
  end

  # Check for link/HTTP URL spam specifically.
  def self.link(data)
    # Only check for spam in the configured mod server.
    return if data.server != CONFIG[:Moderator][:GUILD]

    # Return if the user has only role that's exempt.
    return if LinkSpam.exempt?(data.user)

    # Increment the user's anti-spam bucket if we can.
    LinkSpam.increment_bucket(data.user, data)

    # This will only return the bucket if there are enough items.
    return unless (bucket = LinkSpam.bucket(data.user))

    # Iterate through the entire bucket. The result is the data we need.
    resulting_delete_value = LinkSpam.delete_spam(bucket)

    # Sometimes, due to how quick we delete spam messages, we can end up
    #   with un-deleted messages, so we have to set a "last deleted at timestamp".
    LinkSpam.last_actioned_at(data.user, resulting_delete_value[:time])

    # We might have other threads that are going to delete more spam, so
    #   we don't want to send the same log message multiple times when we can batch it.
    LinkSpam.debounce_logging_messages(data.user, resulting_delete_value)
  end
end
