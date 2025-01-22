# frozen_string_literal: true

module Affections
  # Hug a member.
  def self.hug(data)
    data.respond(content: data.member("target").mention) do |builder|
      builder.add_embed do |embed|
        embed.colour = UI[3]
        embed.title = EMBED[38]
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:HUGS))
        embed.description = format(EMBED[26], data.user.display_name, data.member("target").display_name)
      end
    end
  end
end
