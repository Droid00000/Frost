# frozen_string_literal: true

def admin_houses_menu(data)
  data.send_message do |builder, components|
    components.row do |menu|
      menu.select_menu(custom_id: EMBED[201], placeholder: EMBED[200], min_values: 1) do |options|
        options.option(label: EMBED[208], value: "1320791662129053847", description: EMBED[219],
                       emoji: 1326701956026204281)
        options.option(label: EMBED[202], value: "1320717790310563920", description: EMBED[213],
                       emoji: 1326697875727581235)
        options.option(label: EMBED[212], value: "1106239251512832033", description: EMBED[223],
                       emoji: 1326701718250979338)
        options.option(label: EMBED[211], value: "1322784652015964211", description: EMBED[222],
                       emoji: 1326703610133872700)
        options.option(label: EMBED[209], value: "1320717910875836478", description: EMBED[220],
                       emoji: 1326701195242377287)
        options.option(label: EMBED[205], value: "1320717569342312509", description: EMBED[216],
                       emoji: 1326698977273446452)
        options.option(label: EMBED[204], value: "1320637139976978505", description: EMBED[215],
                       emoji: 1326698213524377610)
        options.option(label: EMBED[206], value: "1318972723434623066", description: EMBED[217],
                       emoji: 1326700670161653810)
        options.option(label: EMBED[207], value: "1322784270431027264", description: EMBED[218],
                       emoji: 1310804270240628816)
        options.option(label: EMBED[203], value: "1320715697566781491", description: EMBED[214],
                       emoji: 1326694246723485776)
        options.option(label: EMBED[210], value: "1320638503109001238", description: EMBED[221],
                       emoji: 1326701448251314206)
        builder.add_embed do |embed|
          embed.colour = UI[6]
          embed.title = EMBED[68]
          embed.timestamp = Time.now
          embed.description = EMBED[224]
          embed.add_field(name: EMBED[225], value: EMBED[226])
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
        end
      end
    end
  end
end

def admin_houses(data)
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
