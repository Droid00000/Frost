# frozen_string_literal: true

def members_back(data)
  unless Frost::Houses.head?(data)
    data.send_message(content: RESPONSE[64])
    return
  end

  Frost::Houses.cult(data).members.take(id * 30).each_with_index do |user, count|
    members << "**#{count + 1}** — #{user.display_name}\n"
  end

  members = members.slice(0, 29)
  members = members.each_slice(15).to_a
  data.edit_response do |builder, components|
    builder.add_embed do |embed|
      embed.timestamp = Time.now
      embed.colour = Frost::Houses.cult(data).color
      embed.title = format(EMBED[185], Frost::Houses.cult(data).name)
      embed.description = format(EMBED[184], Frost::Houses.cult(data).name)
      embed.add_field(name: EMBED[186], value: members[0].join, inline: true)
      embed.add_field(name: EMBED[186], value: members[1].join, inline: true)
    end
  end
end
