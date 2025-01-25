# frozen_string_literal: true

module Affections
  # Nom a member.
  def self.nom(data)
    data.respond(content: data.member("target").mention) do |builder|
      builder.add_embed do |embed|
        embed.title = EMBED[39]
        embed.colour = data.user.highest_role.color
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:NOMS))
        embed.description = format(EMBED[27], data.user.display_name, data.member("target").display_name)
      end
    end
  end
end
