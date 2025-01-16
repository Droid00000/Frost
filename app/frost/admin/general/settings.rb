# frozen_string_literal: true

# An embed with data about a guild's enabled functionality.
def general_settings(data)
  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = EMBED[49]
      embed.colour = UI[5]
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
      if Frost::Boosters::Settings.get(data)
        embed.add_field(name: EMBED[193],
                        value: (EMBED[55] % Frost::Boosters::Settings.get(data)))
      end
      embed.add_field(name: EMBED[194], value: (EMBED[54] % Frost::Pins.get(data))) if Frost::Pins.get(data)
      if Frost::Roles.enabled?(data)
        embed.add_field(name: EMBED[195],
                        value: EMBED[56] % Frost::Roles.all(data).join(", "))
      end
    end
  end
end
