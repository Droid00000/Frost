# frozen_string_literal: true

def pins_setup(data)
  if archiver_records(server: data.server.id, type: :get)
    archiver_records(
      type: :update,
      server: data.server.id,
      channel: data.options['channel']
    )
  else
    archiver_records(
      type: :setup,
      server: data.server.id,
      channel: data.options['channel']
    )
  end

  data.edit_response(content: format(RESPONSE[22], data.options['channel']))
end
