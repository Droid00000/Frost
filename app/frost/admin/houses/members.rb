# frozen_string_literal: true

def members_house(data)
  if CONFIG["Houses"]["STAFF"].include?(data.user.id)
    admin_houses_menu(data)
    return
  end

  unless Frost::Houses.head?(data)
    data.edit_response(content: RESPONSE[94])
    return
  end

  hash = { main: [], cut: [], id: [] }

  Frost::Houses.cult(data).members.each_with_index do |user, count|
    hash[:main] << "**#{count + 1}** — *#{user.display_name}*\n"
  end

  hash[:cut] = hash[:main].first(30).each_slice(15).to_a

  hash[:id] = Frost::Paginator.id("H-UP", hash[:main].each_slice(30).to_a)

  if hash[:main].size > 30
    data.edit_response do |builder, components|
      components.row do |component|
        builder.add_embed do |embed|
          embed.colour = Frost::Houses.cult(data).color
          embed.title = format(EMBED[185], Frost::Houses.cult(data).name)
          embed.add_field(name: EMBED[186], value: hash[:cut][0].join, inline: true)
          embed.add_field(name: EMBED[186], value: hash[:cut][1].join, inline: true)
          embed.description = format(EMBED[184], Frost::Houses.cult(data).members.size.delimit)
          component.button(style: 1, label: EMBED[183], emoji: EMBED[190], custom_id: hash[:id])
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: Frost::Houses.cult(data).icon_url)
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: format(EMBED[199],
                                                                           JSON.parse(hash[:id])["chunk"][1]))
        end
      end
    end
  end

  if hash[:main].size <= 30
    data.edit_response do |builder|
      builder.add_embed do |embed|
        embed.colour = Frost::Houses.cult(data).color
        embed.title = format(EMBED[185], Frost::Houses.cult(data).name)
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: EMBED[198])
        embed.add_field(name: EMBED[186], value: hash[:main].join, inline: true)
        embed.description = format(EMBED[184], Frost::Houses.cult(data).members.size.delimit)
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: Frost::Houses.cult(data).icon_url)
      end
    end
  end
end
