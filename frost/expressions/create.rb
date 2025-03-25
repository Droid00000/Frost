# frozen_string_literal: true

module Emojis
  # Handle an emoji creation command.
  def self.add(data)
    unless data.server.bot.permission?(:manage_emojis)
      data.send_message(content: RESPONSE[1], ephemeral: true)
      return
    end

    emoji = if data.respond_to?(:options)
              data.options["name"] || data.emoji("emoji").name
            else
              data.emoji.name
            end

    begin
      emoji = data.server.add_emoji(emoji, data.emoji.file)
    rescue StandardError => e
      data.send_message(content: code(e.code), ephemeral: true)
      return
    end

    data.send_message(content: format(RESPONSE[1], emoji.use), ephemeral: true)
  end
end
