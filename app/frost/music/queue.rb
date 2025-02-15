# frozen_string_literal: true

module Music
  # The first page of the music queue.
  def self.queue(data)
    unless CALLIOPE.players[data.server.id]
      data.edit_response(content: RESPONSE[82])
      return
    end

    unless CALLIOPE.players[data.server.id].queue
      data.edit_response(content: RESPONSE[79])
      return
    end

    hash = { main: [], cut: [], id: [] }

    fetch_queue(data, :ALL).each_with_index do |track, index|
      hash[:main] << "**#{index + 1}** — [#{track.name}](#{track.url})\n"
    end

    hash[:id] = Frost::Paginator.id("M-UP", hash[:main].each_slice(20).to_a)

    hash[:cut] = hash[:main].first(20).each_slice(10).to_a

    if hash[:main].size > 10
      data.edit_response do |builder, buttons|
        builder.add_embed do |embed|
          buttons.row do |button|
            embed.colour = UI[5]
            embed.title = format(EMBED[149], data.server.name)
            embed.description = format(EMBED[150], fetch_queue(data, :SIZE))
            embed.add_field(name: EMBED[151], value: hash[:cut][0].join, inline: true)
            embed.add_field(name: EMBED[151], value: hash[:cut][1].join, inline: true)
            button.button(style: 1, label: EMBED[183], emoji: EMBED[190], custom_id: hash[:id])
            embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: Frost::Paginator.count(hash[:id]))
          end
        end
      end
    end

    return unless hash[:main].size < 10

    data.edit_response do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[5]
        embed.title = format(EMBED[149], data.server.name)
        embed.description = format(EMBED[150], fetch_queue(data, :SIZE))
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: EMBED[198])
        embed.add_field(name: EMBED[151], value: hash[:main].join, inline: true)
      end
    end
  end
end
