# frozen_string_literal: true

module Emojis
  # Handle an emoji creation command.
  def self.add(data)
    unless data.server.bot.permission?(:manage_emojis)
      data.edit_response(content: RESPONSE[2])
      return
    end

    # Use the user provided name, or fallback to the emoji name.
    name = data.options["name"] || data.emoji("emoji").name

    begin
      emoji = data.server.add_emoji(name, data.emoji("emoji").file,
                                    reason: reason(data))
    rescue StandardError => e
      data.edit_response(content: code(e.code))
      return
    end

    data.edit_response(content: format(RESPONSE[7], emoji.use))
  end
end
