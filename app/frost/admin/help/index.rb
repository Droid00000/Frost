# frozen_string_literal: true

def help_index(data)
  data.send_message do |builder, components|
    components.row do |menu|
      menu.select_menu(custom_id: 'index', placeholder: EMBED[65], min_values: 1) do |options|
        options.option(label: EMBED[57], value: EMBED[81], description: EMBED[61], emoji: 1320928322804388003)
        options.option(label: EMBED[66], value: EMBED[85], description: EMBED[67], emoji: 1320936043020554251)
        options.option(label: EMBED[58], value: EMBED[84], description: EMBED[62], emoji: 1320971944627146752)
        options.option(label: EMBED[60], value: EMBED[83], description: EMBED[64], emoji: 1320933556645793822)
        options.option(label: EMBED[59], value: EMBED[82], description: EMBED[63], emoji: 1320929329307324497)

        builder.add_embed do |embed|
          embed.colour = UI[6]
          embed.title = EMBED[68]
          embed.description = EMBED[69]
          embed.timestamp = Time.at(Time.now)
          embed.add_field(name: EMBED[70], value: EMBED[71])
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
        end
      end
    end
  end
end
