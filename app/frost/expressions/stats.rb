# frozen_string_literal: true

def emoji_stats(data)
  data.message.emoji.each do |emoji|
    Frost::Emojis.emoji(emoji, data.server)
  end
end

Rufus::Scheduler.new.cron '0 0 * * *' do
  Frost::Emojis.drain.each_with_index do |emoji, index|
    Frost::Emojis.add(emoji); Frost::Emojis.delete(index)
  end
end
