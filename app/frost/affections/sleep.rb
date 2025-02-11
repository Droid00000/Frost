# frozen_string_literal: true

module Affections
  # Tell a member to sleep.
  def self.bedtime(data)
    data.respond(content: data.member("target").mention) do |builder|
      builder.add_embed do |embed|
        embed.title = EMBED[42]
        embed.colour = data.user.color
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:SLEEPY))
        embed.description = format(EMBED[23], data.user.display_name, data.member("target").display_name)
      end
    end
  end
end
