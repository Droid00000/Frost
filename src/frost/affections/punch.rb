# frozen_string_literal: true

def punch_member(data)
  return unless CONFIG['Discord']['COMMANDS'].include?(data.user.id)

  data.edit_response(content: "<@#{data.options['target']}>") do |builder|
    builder.add_embed do |embed|
      embed.colour = UI[3]
      embed.title = '**PUNCH**'
      embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:PUNCH))
      embed.description = format(EMBED[24], data.user.display_name, data.options['target'])
    end
  end
end
