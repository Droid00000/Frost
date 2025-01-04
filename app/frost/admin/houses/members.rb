# frozen_string_literal: true

def members_house(data)
  unless Frost::Houses.head?(data)
    data.edit_response(content: RESPONSE[64])
    return
  end

  hash = { main: [], cut: [] } # , page: Frost::Paginator.calculate(data) }

  Frost::Houses.cult(data).members.each_with_index do |user, count|
    hash[:main] << "**#{count + 1}** — *#{user.display_name}*\n"
  end

  hash[:cut] = hash[:main].first(30).each_slice(15).to_a

  if hash[:main].size > 30
    data.edit_response do |builder, components|
      components.row do |component|
        builder.add_embed do |embed|
          embed.timestamp = Time.at(Time.now)
          embed.colour = Frost::Houses.cult(data).color
          embed.title = format(EMBED[185], Frost::Houses.cult(data).name)
          embed.add_field(name: EMBED[186], value: hash[:cut][0].join, inline: true)
          embed.add_field(name: EMBED[186], value: hash[:cut][1].join, inline: true)
          embed.description = format(EMBED[184], Frost::Houses.cult(data).members.size)
          component.button(style: 1, label: EMBED[183], emoji: EMBED[190],
                           custom_id: { type: "H-UP", chunk: [2, hash[:main].size] }.to_json)
        end
      end
    end
  end

  unless hash[:main].size > 30
    data.edit_response do |builder|
      builder.add_embed do |embed|
        embed.timestamp = Time.at(Time.now)
        embed.colour = Frost::Houses.cult(data).color
        embed.title = format(EMBED[185], Frost::Houses.cult(data).name)
        embed.add_field(name: EMBED[186], value: hash[:main].join, inline: true)
        embed.description = format(EMBED[184], Frost::Houses.cult(data).members.size)
      end
    end
  end
end
