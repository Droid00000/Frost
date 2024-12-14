# frozen_string_literal: true

# Returns a string based on the enabled functionality for a guild.
# @return [String] The appropriate string for the type of request.
def settings(type, data)
  case type
  when :archiver
    format(EMBED[50], Frost::Pins.get(data)) if Frost::Pins.get(data)
  when :booster
    format(EMBED[51], Frost::Boosters::Settings.get(data)) if Frost::Boosters::Settings.get(data)
  when :events
    format(EMBED[52], Frost::Roles.get(data)) if Frost::Roles.get?(data)
  end
end

Frost::Boosters::Settings.get(data) ? Frost::Boosters::Settings.get(data) : EMBED[35]

# An embed with data about a guild's enabled functionality.
def general_settings(data)
  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = EMBED[49]
      embed.colour = UI[5]
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
      embed.add_field(name: '``/Booster Perks``', value: settings(:booster, data) || EMBED[35])
      embed.add_field(name: '``/Pin Archiver``', value: settings(:archiver, data) || EMBED[35])
      embed.add_field(name: '``/Event Roles``', value: settings(:events, data) || EMBED[35])
    end
  end
end
