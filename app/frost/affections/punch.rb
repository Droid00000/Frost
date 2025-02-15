# frozen_string_literal: true

module Affections
  # Punch a member.
  def self.punch(data)
    unless CONFIG[:Discord][:CONTRIBUTORS].include?(data.user.id)
      data.respond(content: RESPONSE[18], ephemeral: true)
      return
    end

    data.respond(content: data.member("target").mention) do |builder|
      builder.add_embed do |embed|
        embed.title = EMBED[41]
        embed.colour = data.user.color
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: gif(:PUNCH))
        embed.description = format(EMBED[24], data.user.display_name, data.member("target").display_name)
      end
    end
  end
end
