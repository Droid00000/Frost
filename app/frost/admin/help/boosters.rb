# frozen_string_literal: true

def help_booster(data)
  data.send_message(ephemeral: true) do |builder, components|
    components.row do |buttons|
      builder.add_embed do |embed|
        embed.colour = UI[7]
        embed.title = EMBED[48]
        embed.description = EMBED[120]
        embed.timestamp = Time.at(Time.now)
        embed.add_field(name: EMBED[117], value: EMBED[121])
        embed.add_field(name: EMBED[118], value: EMBED[123])
        embed.add_field(name: EMBED[119], value: EMBED[122])
        embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
        buttons.button(label: EMBED[124], custom_id: EMBED[125], style: 1, emoji: 1295667609961758731)
      end
    end
  end
end
