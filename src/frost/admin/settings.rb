# frozen_string_literal: true

# Returns a string based on the enabled functionality for a guild.
# @return [String] The appropriate string for the type of request.
def settings(type, server)
  case type
  when :archiver
    if archiver_records(server: server, type: :check)
      "**Archive Channel:** <##{archiver_records(server: server, type: :get)}>"
    else
      EMBED[35]
    end
  when :booster
    if booster_records(server: server, type: :enabled)
      "**Hoist Role:** <@&#{booster_records(server: server, type: :hoist_role)}>"
    else
      EMBED[35]
    end
  when :events
    if event_records(server: server, type: :enabled)
      "**Roles:** #{event_records(server: server, type: :get_roles).join(', ')}"
    else
      EMBED[35]
    end
  end
end

# An embed with data about a guild's enabled functionality.
def server_settings(data)
  data.edit_response do |builder|
    builder.add_embed do |embed|
      embed.title = '**Server Settings**'
      embed.colour = UI[5]
      embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: UI[1])
      embed.add_field(name: '``/Booster Perks``', value: settings(:booster, data.server.id).to_s)
      embed.add_field(name: '``/Pin Archiver``', value: settings(:archiver, data.server.id).to_s)
      embed.add_field(name: '``/Event Roles``', value: settings(:events, data.server.id).to_s)
    end
  end
end
