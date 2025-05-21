# frozen_string_literal: true

module Moderation
  # Change someone's nickname.
  def self.nickname(data)
    unless data.server.bot.permission?(:manage_nicknames)
      data.edit_response(content: RESPONSE[1])
      return
    end

    unless data.user.owner?
      if hierarchy(data.member("member")) >= hierarchy(data.user)
        data.edit_response(content: format(RESPONSE[5], "you"))
        return
      end
    end

    unless data.member("member").current_bot?
      if hierarchy(data.member("member")) >= hierarchy(data.server.bot)
        data.edit_response(content: format(RESPONSE[5], "me"))
        return
      end
    end

    data.member("member").set_nick(data.options["nickname"],
                                   "#{data.user.name} (ID: #{data.user.id})")

    data.edit_response(content: RESPONSE[4])
  end
end
