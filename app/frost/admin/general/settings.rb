# frozen_string_literal: true

# An embed with data about a guild's enabled functionality.
def general_settings(data)
  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = EMBED[49]
      embed.colour = UI[5]
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
      embed.add_field(name: "``/Booster Perks``",
                      value: Frost::Boosters::Settings.get?(data) ? (EMBED[55] % Frost::Boosters::Settings.get(data)) : EMBED[35])
      embed.add_field(name: "``/Pin Archiver``",
                      value: Frost::Pins.get?(data) ? (EMBED[54] % Frost::Pins.get(data)) : EMBED[35])
      embed.add_field(name: "``/Event Roles``",
                      value: Frost::Roles.enabled?(data) ? (EMBED[56] % Frost::Roles.all(data).join(", ")) : EMBED[35])
    end
  end
end
