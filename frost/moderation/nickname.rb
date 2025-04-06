# frozen_string_literal: true

module Moderation
  # Change someone's nickname.
  def self.nickname(data)
    unless data.server.bot.permission?(:manage_nicknames)
      data.edit_response(content: RESPONSE[66])
      return
    end

    if hierarchy(data.member("member")) >= hierarchy(data.user)
      data.edit_response(content: RESPONSE[58])
      return
    end

    if hierarchy(data.member("member")) >= hierarchy(data.server.bot)
      data.edit_response(content: RESPONSE[69])
      return
    end

    data.member("member").nickname = data.options["nickname"]

    data.edit_response(content: format(RESPONSE[65], data.options["member"]))
  end
end
