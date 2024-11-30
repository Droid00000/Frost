# frozen_string_literal: true

def punch_member(data)
  unless CONFIG['Discord']['COMMANDS'].include?(data.user.id)
    data.respond(content: RESPONSE[18], ephemeral: true)
    return
  end

  data.respond(content: data.member('target').mention) do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[3]
      embed.title = EMBED[41]
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:PUNCH))
      embed.description = format(EMBED[24], data.user.display_name, data.options['target'])
    end
  end
end
