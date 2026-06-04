# frozen_string_literal: true

module Affections
  # Handle all affection related commands with one main method.
  def self.call(data)
    # We can use the name of the command to check the action type.
    name = data.command_name

    embed = {
      title: HEADERS[name],
      image: { url: const_get(name.upcase).sample },
      color: data.server_integration? ? data.user.color : 0,
      description: format(RESPONSE[name], data.user.display_name,
                          data.options_user("target").display_name)
    }

    # NOTE: the resolved user gets cached, so we can just use {Bot#user}.
    user_id = data.options["target"]

    # NOTE: don't ever defer these commands since that breaks the mention.
    data.respond(content: data.bot.user(user_id)&.mention, embeds: [embed])
  end
end
