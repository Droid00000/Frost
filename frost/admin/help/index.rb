# frozen_string_literal: true

def help_index(data)
  data.send_message do |builder, components|
    components.row do |menu|
      menu.select_menu(custom_id: EMBED[126], placeholder: EMBED[65], min_values: 1) do |options|
        options.option(label: EMBED[57], value: EMBED[81], description: EMBED[61], emoji: 1_320_928_322_804_388_003)
        options.option(label: EMBED[238], value: EMBED[252], description: EMBED[239], emoji: 1_335_520_417_468_911_617)
        options.option(label: EMBED[66], value: EMBED[85], description: EMBED[67], emoji: 1_320_936_043_020_554_251)
        options.option(label: EMBED[58], value: EMBED[84], description: EMBED[62], emoji: 1_320_971_944_627_146_752)
        options.option(label: EMBED[60], value: EMBED[83], description: EMBED[64], emoji: 1_320_933_556_645_793_822)
        options.option(label: EMBED[59], value: EMBED[82], description: EMBED[63], emoji: 1_320_929_329_307_324_497)

        builder.add_embed do |embed|
          embed.colour = UI[6]
          embed.title = EMBED[68]
          embed.timestamp = Time.now
          embed.description = EMBED[69]
          embed.add_field(name: EMBED[70], value: EMBED[71])
          embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
          embed.add_field(name: EMBED[196], value: format(EMBED[197], data.bot.count_servers, data.bot.count_members, data.bot.count_channels))
        end
      end
    end
  end
end
