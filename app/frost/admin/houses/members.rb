# frozen_string_literal: true

def members_house(data)
  unless Frost::Houses.head?(data)
    data.edit_response(content: RESPONSE[64])
    return
  end

  members = []

  data.server.role(Frost::Houses.cult(data)).members.each_with_index do |user, count|
    members << "**#{count + 1}** — #{user.display_name}\n"
  end

  members.each_slice(15).to_a if members.count > 15

  data.edit_response do |builder, components|
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
