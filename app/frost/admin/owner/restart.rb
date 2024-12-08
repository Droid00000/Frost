# frozen_string_literal: true

# Restarts the Gateway connection.
def owner_restart(data)
  if data.user.id == CONFIG['Discord']['OWNER']&.to_i
    data.edit_response(content: RESPONSE[50])
    exec('bundle exec ruby core.rb')
  else
    data.edit_response(content: RESPONSE[18])
  end
end
