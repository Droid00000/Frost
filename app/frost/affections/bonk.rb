# frozen_string_literal: true

module Affections
  # Bonk a member.
  def self.bonk(data)
    data.respond(content: data.member("target").mention) do |builder|
      builder.add_embed do |embed|
        embed.title = EMBED[37]
        embed.colour = data.user.color
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:BONK))
        embed.description = format(EMBED[28], data.user.display_name, data.member("target").display_name)
      end
    end
  end
end
