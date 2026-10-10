# frozen_string_literal: true

module Actions
  # Event handler for affection commands.
  def self.call(event, name)
    # If the command is from a DM, don't resolve a member.
    target = if event.resolved.members.none?
               event.bot.user(event.options[:target].to_i)
             else
               event.resolved.members[event.options[:target].to_i]
             end

    affection_embed = {
      title: HEADERS[name],
      image: { url: GIFS[name].sample },
      color: (event.user.color.to_i if event.guild_integration?),
      description: format(RESPONSES[name], event.user.display_name,
                          target&.display_name || "@unknown-user")
    }

    # NOTE: Do not defer these commands since that breaks the mention.
    event.respond(content: target&.mention, embeds: [affection_embed])
  end
end
