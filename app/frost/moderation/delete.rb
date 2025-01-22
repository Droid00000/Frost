# frozen_string_literal: true

module Moderation
  # Purge messages.
  def self.purge(data)
    unless data.server.bot.permission?(:manage_messages, data.channel)
      data.edit_response(content: RESPONSE[67])
      return
    end

    count = 0

    ([1] * data.options["amount"]).each_slice(100) do |chunk|
      count += data.channel.prune(chunk.sum)
    end

    data.edit_response(content: format(RESPONSE[68], count))
  end
end
