# frozen_string_literal: true

def birthday_date(data)
  if birthday_records(user: data.user.id, type: :check_user)
    birthday_records(
      type: :add_birthday,
      user: data.user.id,
      server: data.server.id,
      date: resolve_birthday(data.options['date'])
    )

    data.edit_response(content: RESPONSE[75] % data.options['date'])
    return
  end

  birthday_records(
    type: :update_birthday,
    user: data.user.id,
    date: resolve_birthday(data.options['date'])
  )

  data.edit_response(content: RESPONSE[75] % data.options['date'])
end
