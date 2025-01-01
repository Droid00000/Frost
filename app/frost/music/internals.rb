# frozen_string_literal: true

# intercepts the voice state update.
def process_state(data)
  return if data.old_channel && data.user.id != CONFIG["Lavalink"]["ID"]

  CALLIOPE.connect(data.server.id, session: data.session_id)
end

# Intercepts the voice server update.
def process_server(data)
  CALLIOPE.connect(data.server.id, token: data.token, endpoint: data.endpoint)
end

# Convienent way to get the queue.
def fetch_queue(data, mode)
  CALLIOPE.players[data.server.id].lava_queue.last(15) unless mode == :MAX

  CALLIOPE.players[data.server.id].lava_queue.first(15) unless mode == :BOTTOM
end

# Convienent way to connect from a voice channel.
def gateway_voice_disconnect(data)
  return if data.server.bot.voice_channel.nil?

  data.bot.gateway.send_voice_state_update(data.server.id, nil, false, false)
end

# Convienent way to connect to a voice channel.
def gateway_voice_connect(data)
  return unless data.server.bot.voice_channel.nil?

  data.bot.gateway.send_voice_state_update(data.server.id, data.user.voice_channel.id, false, false)
end
