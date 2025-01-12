# frozen_string_literal: true

def music_pages(data)
  unless CALLIOPE.players[data.server.id]
    data.edit_response(content: RESPONSE[82])
    return
  end

  if data.server.bot.voice_channel.nil?
    data.edit_response(content: RESPONSE[75])
    return
  end

  if CALLIOPE.players[data.server.id].paused?
    data.edit_response(content: RESPONSE[81])
    return
  end

  unless CALLIOPE.players[data.server.id].queue
    data.edit_response(content: RESPONSE[79])
    return
  end

  page = Frost::Paginator.new(data).paginate

  if page.second_row?
    data.edit_response(components: page.buttons) do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[5]
        embed.title = format(EMBED[149], data.server.name)
        embed.description = format(EMBED[150], fetch_queue(data, :SIZE))
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: page.index)
        embed.add_field(name: EMBED[151], value: page.tracks(1), inline: true)
        embed.add_field(name: EMBED[151], value: page.tracks(2), inline: true)
      end
    end
  end

  unless page.second_row?
    data.edit_response(components: page.buttons) do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[5]
        embed.title = format(EMBED[149], data.server.name)
        embed.description = format(EMBED[150], fetch_queue(data, :SIZE))
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: page.index)
        embed.add_field(name: EMBED[151], value: page.tracks(1), inline: true)
      end
    end
  end
end
