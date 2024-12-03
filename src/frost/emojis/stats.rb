# frozen_string_literal: true

module Frost
  # Represents an Emoji cache.
  class Emoji
    # An array to store emojis.
    @@emoji = []

    # @param emoji [Discordrb::Emoji]
    # @param server [Discordrb::Server]
    def initalize(emoji, server)
      @@emoji << { emoji: emoji, server: server }
    end

    # Returns all emojis.
    def self.get_emojis
      @@emoji
    end
  end
end

def emoji_stats(data)
  data.message.emoji.each do |emoji|
    Frost::Emoji.new(emoji: emoji, server: data.server)
  end
end

Rufus::Scheduler.new.cron '6 3 * * 5' do
  while emoji = Frost::Emoji.get_emojis.shift
    emoji_records(emoji: emoji[:emoji], server: emoji[:server], type: :add_emoji)
  end
end
