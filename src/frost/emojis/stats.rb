#  frozen_string_literal: true

def emoji_stats(data)
  data.message.emoji.each do |emoji|
    emoji_records(emoji: emoji.id, server: data.server.id, type: :add_emoji)
  end
end
