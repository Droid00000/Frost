# frozen_string_literal: true

def members_page(data)
  unless Frost::Houses.head?(data)
    data.send_message(content: RESPONSE[94])
    return
  end

  page = Frost::Paginator.new(data, Frost::Houses.all)

  if page.second_row?
    data.edit_response(components: page.buttons) do |builder|
      builder.add_embed do |embed|
        embed.timestamp = Time.now
        embed.colour = Frost::Houses.cult(data).color
        embed.title = format(EMBED[185], Frost::Houses.cult(data).name)
        embed.add_field(name: EMBED[186], value: page.map(0), inline: true)
        embed.add_field(name: EMBED[186], value: page.map(1), inline: true)
        embed.description = format(EMBED[184], Frost::Houses.cult(data).members.size)
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: Frost::Houses.cult(data).icon_url)
      end
    end
  end

  unless page.second_row?
    data.edit_response(components: page.buttons) do |builder|
      builder.add_embed do |embed|
        embed.timestamp = Time.now
        embed.colour = Frost::Houses.cult(data).color
        embed.title = format(EMBED[185], Frost::Houses.cult(data).name)
        embed.add_field(name: EMBED[186], value: page.map(0), inline: true)
        embed.description = format(EMBED[184], Frost::Houses.cult(data).members.size)
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: Frost::Houses.cult(data).icon_url)
      end
    end
  end
end
