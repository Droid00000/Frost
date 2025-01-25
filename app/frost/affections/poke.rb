# frozen_string_literal: true

module Affections
  # Poke a member.
  def self.poke(data)
    data.respond(content: data.member("target").mention) do |builder|
      builder.add_embed do |embed|
        embed.title = EMBED[40]
        embed.colour = data.user.highest_role.color
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:POKES))
        embed.description = format(EMBED[25], data.user.display_name, data.member("target").display_name)
      end
    end
  end
end
