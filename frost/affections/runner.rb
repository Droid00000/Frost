# frozen_string_literal: true

module Affections
  # Handle all affection related commands with one main method.
  def self.call(data)
    # We can use the name of the command to check the action type.
    name = data.command_name

    # I'm glad we switched away from using the very verbose builder.
    embed = {
      title: HEADERS[name],
      image: { url: const_get(name.upcase).sample },
      color: data.server_integration? ? data.user.color : 0,
      description: format(RESPONSE[name], data.user.display_name,
                          data.resolved_user("target").display_name)
    }

    # NOTE: don't ever defer these commands, otherwise the mention doesn't work.
    data.respond(content: data.resolved_user("target").mention, embeds: [embed])
  end
end
