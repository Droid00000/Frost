# frozen_string_literal: true

module Moderation
  # Block a member.
  def self.block(data)
    unless data.server.bot.permission?(:manage_roles)
      data.edit_response(content: RESPONSE[49])
      return
    end

    if data.server.bot.id == data.options["member"]
      data.edit_response(content: RESPONSE[58])
      return
    end

    if data.user.id == data.options["member"]
      data.edit_response(content: RESPONSE[58])
      return
    end

    if data.member("member").highest_role.position >= data.user.highest_role.position
      data.edit_response(content: RESPONSE[58])
      return
    end

    overwrite = Discordrb::Overwrite.new(data.member("member"), deny: 1024)

    if data.options["cascade"]
      data.server.channels.each do |channel|
        next unless data.server.bot.permission?(:manage_roles, channel)

        channel.produce_overwrite(overwrite, reason: REASON[8])
      end
    end

    unless data.options["cascade"]
      data.channel.produce_overwrite(overwrite, reason: REASON[8])
    end

    data.edit_response(content: format(RESPONSE[57], data.options["member"]))
  end
end
