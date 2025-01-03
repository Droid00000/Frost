# frozen_string_literal: true

def members_forward(data)
  unless Frost::Houses.head?(data)
    data.send_message(content: RESPONSE[64])
    return
  end

  members, id = [], data.custom_id.scan(/\d+/).first.to_i

  Frost::Houses.cult(data).members.drop(id * 30).each_with_index do |user, count|
    members << "**#{count + 1}** — #{user.display_name}\n"
  end

  if members.size >= 30
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

        unless (id > members.size)
          components.row do |component|
            component.button(style: 4, label: EMBED[182], emoji: EMBED[189], custom_id: format(EMBED[192], id + 1))
            component.button(style: 1, label: EMBED[183], emoji: EMBED[190], custom_id: format(EMBED[191], id + 1))
          end
        end
      end
    end
  else
    data.edit_response do |builder, components|
      builder.add_embed do |embed|
        components.row do |component|
          embed.timestamp = Time.now
          embed.colour = Frost::Houses.cult(data).color
          embed.title = format(EMBED[185], Frost::Houses.cult(data).name)
          embed.add_field(name: EMBED[186], value: members.join, inline: true)
          embed.description = format(EMBED[184], Frost::Houses.cult(data).name)
          component.button(style: 4, label: EMBED[182], emoji: EMBED[189], custom_id: format(EMBED[192], id + 1))
          component.button(style: 1, label: EMBED[183], emoji: EMBED[190],
                           custom_id: format(EMBED[191], id + 1)) unless (id == 1 || id > members.size)
        end
      end
    end
  end
end
