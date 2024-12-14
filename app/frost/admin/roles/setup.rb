# frozen_string_literal: true

# Adds a new role to the event roles database.
def roles_setup(data)
  unless Frost::Role.get?(data)
    data.edit_response(content: RESPONSE[23])
    return
  end

  Frost::Role.add(data)

  data.edit_response(content: format(RESPONSE[24], data.options['role']))
end
