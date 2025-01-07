# frozen_string_literal: true

def delete_messages(data)
  unless data.server.bot.permission?(:manage_messages)
    data.edit_response(content: RESPONSE[67])
    return
  end

  messages = []

  ([1] * data.options["amount"]).each_slice(100) do |chunk|
    messages << chunk.sum
  end

  messages = messages.map do |chunk|
    data.channel.prune(chunk)
  end

  data.edit_response(content: format(RESPONSE[68], messages.sum))
end
