# frozen_string_literal: true

module Emojis
  # Handle a select click
  def self.click(data)
    unless data.server.bot.permission?(:manage_emojis)
      data.send_message(content: RESPONSE[48], ephemeral: true)
      return
    end

    begin
      emoji = data.server.add_emoji(data.emoji.name, data.emoji.file)
    rescue StandardError
      data.send_message(content: RESPONSE[45], ephemeral: true)
      return
    end

    data.send_message(content: "#{RESPONSE[43]} #{emoji.use}", ephemeral: true)
  end
end
