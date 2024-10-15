# frozen_string_literal: true

require_relative '../data/constants'
require_relative '../data/functions'
require 'shellwords'
require 'discordrb'

def voice_play(data)
  if data.user.voice_channel.nil?
    data.edit_response(content: RESPONSE[43])
    return
  end

  unless valid_song?(data.options['url'])
    data.edit_response(content: RESPONSE[44])
    return
  end

  data.edit_response(content: "#{RESPONSE[45]} #{EMOJI[5]}")

  data.bot.voice_connect(data.user.voice_channel)
  data.bot.voice.play_io(IO.popen("yt-dlp -q -o - #{Shellwords.escape(data.options['url'])}"))
end
