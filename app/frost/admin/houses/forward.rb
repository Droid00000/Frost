# frozen_string_literal: true

def members_forward(data)
  unless Frost::Houses.head?(data)
    data.send_message(content: RESPONSE[64])
    return
  end

  members = []

  Frost::Houses.cult(data).members.drop(data.custom_id.scan(/\d+/).first.to_i * 30).each_with_index do |user, count|
    members << "**#{count + 1}** — #{user.display_name}\n"
  end

  if members.size > 30
    members = members.slice(0, 29)
    members = members.each_slice(15).to_a
    data.edit_response do |builder, components|
      components.row do |component|
        builder.add_embed do |embed|
          embed.timestamp = Time.at(Time.now)
          embed.colour = Frost::Houses.cult(data).color
          embed.title = format(EMBED[185], Frost::Houses.cult(data).name)
          embed.description = format(EMBED[184], Frost::Houses.cult(data).name)
          embed.add_field(name: EMBED[186], value: members[0].join, inline: true)
          embed.add_field(name: EMBED[186], value: members[1].join, inline: true)
          component.button(style: 4, label: EMBED[182], emoji: EMBED[189], custom_id: EMBED[187])
          component.button(style: 1, label: EMBED[183], emoji: EMBED[190], custom_id: EMBED[188])
        end
      end
    end
  else
    data.edit_response do |builder, components|
      components.row do |component|
        builder.add_embed do |embed|
          embed.timestamp = Time.at(Time.now)
          embed.colour = Frost::Houses.cult(data).color
          embed.title = format(EMBED[185], Frost::Houses.cult(data).name)
          embed.add_field(name: EMBED[186], value: members.join, inline: true)
          embed.description = format(EMBED[184], Frost::Houses.cult(data).name)
          component.button(style: 4, label: EMBED[182], emoji: EMBED[189], custom_id: EMBED[187])
        end
      end
    end
  end
end
