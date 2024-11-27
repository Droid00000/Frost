# frozen_string_literal: true

def block_member(data)
  unless data.bot.profile.on(data.server).permission?(:manage_channels)
    data.edit_response(content: RESPONSE[49])
    return
  end

  overwrite = Overwrite.new(data.member('member'), deny: 1024)

  data.channel.define_overwrite(overwrite, reason: REASON[12])

  data.edit_response(content: format(RESPONSE[57], data.options['member']))
end
