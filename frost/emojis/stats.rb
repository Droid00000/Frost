# frozen_string_literal: true

module Emojis
  # Stats related stuff.
  def self.cache(data)
    data.message.emoji.each do |emoji|
      Frost::Emojis.new(emoji, data.server)
    end
  end

  def self.react(data)
    return unless data.emoji.id

    Frost::Emojis.new(data.emoji, data.server)
  end

  def self.thread(data)
    data.channel.join if data.channel.thread?
  end

  def self.stats(data)
    unless Frost::Emojis.any?(data)
      data.edit_response(content: RESPONSE[64])
      return
    end

    emojis = []

    Frost::Emojis.top(data).map do |emoji|
      next unless data.bot.emoji(emoji[:emoji_id])

      emojis << { main: data.bot.emoji(emoji[:emoji_id]), count: emoji[:balance] }
    end

    emojis.map! do |stats|
      "#{emoji[:main].mention} — #{emoji[:main].name} **(#{emoji[:count].delimit})**\n"
    end

    data.edit_response do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[6]
        embed.timestamp = Time.now
        embed.description = EMBED[51]
        embed.title = format(EMBED[50], data.server.name)
        embed.add_field(name: EMBED[52], value: emojis.join, inline: true)
      end
    end
  end
end
