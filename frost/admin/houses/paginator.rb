# frozen_string_literal: true

def members_page(data)
  unless data.message.initiating_user == data.user.id || CONFIG[:Houses][:STAFF].include?(data.user.id)
    data.send_message(content: RESPONSE[96], ephemeral: true)
    return
  end

  page = Frost::Paginator.new(data, Frost::Houses.all).paginate

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

  return if page.second_row?

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
