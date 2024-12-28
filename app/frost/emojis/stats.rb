# frozen_string_literal: true

def emoji_stats(data)
  data.message.emoji.each do |emoji|
    Frost::Emojis.new(emoji, data.server)
  end
end

def reaction_stats(data)
  return unless data.emoji.id

  Frost::Emojis.new(data.emoji, data.server)
end

Rufus::Scheduler.new.cron "0 0 * * *" do
  while (emoji = Frost::Emojis.drain.shift)
    Frost::Emojis.add(emoji: emoji[:emoji], guild: emoji[:guild])
  end
end

def stats_command(data)
  unless Frost::Emojis.any?(data)
    data.edit_response(content: RESPONSE[64])
    return
  end

  emojis = [[], []]

  Frost::Emojis.top(data).map do |emoji|
    next unless data.bot.emoji(emoji[:emoji_id])

    emojis[0] << { main: data.bot.emoji(emoji[:emoji_id]), count: emoji[:balance] }
  end

  Frost::Emojis.bottom(data).map do |emoji|
    next unless data.bot.emoji(emoji[:emoji_id])

    emojis[1] << { main: data.bot.emoji(emoji[:emoji_id]), count: emoji[:balance] }
  end

  emojis.each do |stats|
    stats.map! do |emoji|
      "#{emoji[:main].mention} — #{emoji[:main].name} **(#{emoji[:count]})**\n"
    end
  end

  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[6]
      embed.description = EMBED[51]
      embed.timestamp = Time.at(Time.now)
      embed.title = format(EMBED[50], data.server.name)
      embed.add_field(name: EMBED[52], value: emojis[0].join, inline: true)
      embed.add_field(name: EMBED[53], value: emojis[1].join, inline: true)
    end
  end
end
