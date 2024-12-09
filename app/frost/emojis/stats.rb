# frozen_string_literal: true

def emoji_stats(data)
  data.message.emoji.each do |emoji|
    Frost::Emojis.add(emoji, data.server)
  end
end

Rufus::Scheduler.new.cron '0 0 * * *' do
  while (emoji = Frost::Emojis.get_emojis.shift)
    emoji_records(emoji: emoji[:emoji], server: emoji[:server], type: :add_emoji)
  end
end
