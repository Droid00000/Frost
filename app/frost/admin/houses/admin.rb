# frozen_string_literal: true

def admin_houses_menu(data)
  data.send_message do |builder, components|
    components.row do |menu|
      builder.add_embed do |embed|
        embed.colour = UI[6]
        embed.title = EMBED[68]
        embed.timestamp = Time.now
        embed.description = EMBED[224]
        embed.add_field(name: EMBED[225], value: EMBED[226])
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
        menu.select_menu(custom_id: EMBED[201], placeholder: EMBED[200], min_values: 1) do |options|
          options.option(label: EMBED[208], value: EMBED[227], description: EMBED[219], emoji: 1326701956026204281)
          options.option(label: EMBED[202], value: EMBED[228], description: EMBED[213], emoji: 1326697875727581235)
          options.option(label: EMBED[212], value: EMBED[229], description: EMBED[223], emoji: 1326701718250979338)
          options.option(label: EMBED[211], value: EMBED[230], description: EMBED[222], emoji: 1326703610133872700)
          options.option(label: EMBED[209], value: EMBED[231], description: EMBED[220], emoji: 1326701195242377287)
          options.option(label: EMBED[205], value: EMBED[232], description: EMBED[216], emoji: 1326698977273446452)
          options.option(label: EMBED[204], value: EMBED[233], description: EMBED[215], emoji: 1326698213524377610)
          options.option(label: EMBED[206], value: EMBED[234], description: EMBED[217], emoji: 1326700670161653810)
          options.option(label: EMBED[207], value: EMBED[235], description: EMBED[218], emoji: 1310804270240628816)
          options.option(label: EMBED[203], value: EMBED[236], description: EMBED[214], emoji: 1326694246723485776)
          options.option(label: EMBED[210], value: EMBED[237], description: EMBED[221], emoji: 1326701448251314206)
        end
      end
    end
  end
end

def admin_house(data)
  unless data.message.interaction.user.id == data.user.id
    data.send_message(content: RESPONSE[95])
    return
  end

  hash = { main: [], cut: [], id: [] }

  data.server.role(data.values).members.each_with_index do |user, count|
    hash[:main] << "**#{count + 1}** — *#{user.display_name}*\n"
  end

  hash[:cut] = hash[:main].first(30).each_slice(15).to_a

  hash[:id] = Frost::Paginator.id("AH-UP", hash[:main].each_slice(30).to_a, data.values)

  if hash[:main].size > 30
    data.send_message do |builder, components|
      components.row do |component|
        builder.add_embed do |embed|
          embed.colour = data.server.role(data.values).color
          embed.title = format(EMBED[185], data.server.role(data.values).name)
          embed.add_field(name: EMBED[186], value: hash[:cut][0].join, inline: true)
          embed.add_field(name: EMBED[186], value: hash[:cut][1].join, inline: true)
          component.button(style: 1, label: EMBED[183], emoji: EMBED[190], custom_id: hash[:id])
          embed.description = format(EMBED[184], data.server.role(data.values).members.size.delimit)
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: data.server.role(data.values).icon_url)
          embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: format(EMBED[199],
                                                                           JSON.parse(hash[:id])["chunk"][1]))
        end
      end
    end
  end

  if hash[:main].size <= 30
    data.send_message do |builder|
      builder.add_embed do |embed|
        embed.colour = data.server.role(data.values).color
        embed.title = format(EMBED[185], data.server.role(data.values).name)
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: EMBED[198])
        embed.add_field(name: EMBED[186], value: hash[:main].join, inline: true)
        embed.description = format(EMBED[184], data.server.role(data.values).members.size.delimit)
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: data.server.role(data.values).icon_url)
      end
    end
  end
end

def staff_page(data)
  unless data.message.interaction.user.id == data.user.id
    data.send_message(content: RESPONSE[95])
    return
  end

  page = Frost::Paginator.new(data).paginate

  if page.second_row?
    data.edit_response(components: page.buttons) do |builder|
      builder.add_embed do |embed|
        embed.colour = page.role.color
        embed.title = format(EMBED[185], page.role.name)
        embed.add_field(name: EMBED[186], value: page.map(1), inline: true)
        embed.add_field(name: EMBED[186], value: page.map(2), inline: true)
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: page.index)
        embed.description = format(EMBED[184], page.role.members.size.delimit)
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: page.role.icon_url)
      end
    end
  end

  unless page.second_row?
    data.edit_response(components: page.buttons) do |builder|
      builder.add_embed do |embed|
        embed.colour = page.role.color
        embed.title = format(EMBED[185], page.role.name)
        embed.add_field(name: EMBED[186], value: page.map(1), inline: true)
        embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: page.index)
        embed.description = format(EMBED[184], page.role.members.size.delimit)
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: page.role.icon_url)
      end
    end
  end
end
