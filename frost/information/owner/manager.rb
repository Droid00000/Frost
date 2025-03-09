# frozen_string_literal: true

module Owner
  # Disconnect the bot from the gateway.
  def self.shutdown(data)
    unless data.user.id == CONFIG[:Discord][:OWNER]&.to_i
      data.edit_response(content: RESPONSE[18])
      return
    end

    bot.stop && data.edit_response(content: RESPONSE[19])
  end

  # Reconnect the bot to the gateway.
  def self.restart
    unless data.user.id == CONFIG[:Discord][:OWNER]&.to_i
      data.edit_response(content: RESPONSE[18])
      return
    end

    exec("bundle exec ruby --yjit core.rb")
  end
end
