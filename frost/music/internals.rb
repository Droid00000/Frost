# frozen_string_literal: true

# intercepts the voice state update.
def process_state(data)
  return if data.old_channel || data.user.id != CONFIG[:Lavalink][:ID]

  CALLIOPE.connect(data.server.id, session: data.session_id)
end

# Intercepts the voice server update.
def process_server(data)
  CALLIOPE.connect(data.server.id, token: data.token, endpoint: data.endpoint)
end

# Convienent way to get the queue.
def fetch_queue(data, mode)
  return CALLIOPE.players[data.server.id].queue if mode == :ALL

  CALLIOPE.players[data.server.id].queue.size if mode == :SIZE
end

# Convienent way to disconnect from a voice channel.
def gateway_voice_disconnect(data)
  return if data.server.bot.voice_channel.nil?

  data.bot.gateway.send_voice_state_update(data.server.id, nil, false, false)
end

# Convienent way to connect to a voice channel.
def gateway_voice_connect(data)
  return unless data.server.bot.voice_channel.nil?

  data.bot.gateway.send_voice_state_update(data.server.id, data.user.voice_channel.id, false, false)
end

# Convinent way to move voice channels.
def gateway_voice_move(data)
  return if data.server.bot.voice_channel.nil?

  data.bot.gateway.send_voice_state_update(data.server.id, nil, false, false)

  data.bot.gateway.send_voice_state_update(data.server.id, data.options["channel"], false, false)
end
