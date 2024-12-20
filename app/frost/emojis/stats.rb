# frozen_string_literal: true

def emoji_stats(data)
  data.message.emoji.each do |emoji|
    Frost::Emojis.emoji(emoji, data.server)
  end
end

Rufus::Scheduler.new.cron '0 0 * * *' do
  Frost::Emojis.drain.each_with_index do |emoji, index|
    Frost::Emojis.produce(emoji, index)
  end
end

def stats_command(data)
  unless Frost::Emojis.any?(data)
    data.edit_response(content: RESPONSE[])
    return
  end

  emojis = [[], []]

  Frost::Emojis.top(data).map do |emoji|
    next unless data.bot.emoji(emoji[:emoji_id])

    emojis[0] << { main: data.bot.emoji(emoji[:emoji_id]), count: emoji[:balance]}
  end

  Frost::Emojis.bottom(data).map do |emoji|
    next unless data.bot.emoji(emoji[:emoji_id])

    emojis[0] << { main: data.bot.emoji(emoji[:emoji_id]), count: emoji[:balance]}
  end

  emojis[0].map! do |emoji|
    "#{emoji[:main].mention} — #{emoji[:main].name} **(#{emoji[:count]})**\n"
  end

  emojis[1].map! do |emoji|
    "#{emoji[:main].mention} — #{emoji[:main].name} **(#{emoji[:count]})**\n"
  end

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[9]
      embed.description = EMBED[51]
      embed.timestamp = Time.at(Time.now)
      embed.title = format(EMBED[50], data.server.name)
      embed.add_field(name: EMBED[52], value: emojis[0].join, inline: true)
      embed.add_field(name: EMBED[53], value: emojis[1].join, inline: true)
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: data.server.icon_url)
    end
  end
end
