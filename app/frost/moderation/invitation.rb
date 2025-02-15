# frozen_string_literal: true

module Moderation
  # Pause invites for a server.
  def self.pause(data)
    unless data.server.bot.permission?(:manage_server)
      data.edit_response(content: RESPONSE[52])
      return
    end

    if data.options["duration"]
      begin
        time = Rufus::Scheduler.parse_duration(data.options["duration"])
      rescue StandardError
        return data.edit_response(content: RESPONSE[118])
      end
    end

    if time && (Time.now + time) > (Time.now + 86_400)
      data.edit_response(content: RESPONSE[119])
      return
    end

    if time
      data.server.pause_invites(Time.now + time)
    else
      data.server.features = data.server.features + [:invites_disabled]
    end

    data.edit_response(content: RESPONSE[120])
  end

  # Resume invites for a server.
  def self.resume(data)
    unless data.server.bot.permission?(:manage_server)
      data.edit_response(content: RESPONSE[52])
      return
    end

    unless data.server.invites_paused?
      data.edit_response(content: RESPONSE[121])
      return
    end

    if data.server.invites_paused?
      data.server.pause_invites(nil)
      data.server.features = data.server.features - [:invites_disabled]
    end

    data.edit_response(content: RESPONSE[122])
  end
end
