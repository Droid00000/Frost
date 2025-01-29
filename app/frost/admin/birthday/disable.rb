# frozen_string_literal: true

def disable_birthdays(data)
  unless data.user.permission?(:administrator)
    data.edit_response(content: RESPONSE[1])
    return
  end

  Frost::Birthdays::Settings.disable(data)

  if data.options["prune"]
    Frost::Birthdays.prune(data)
  end

  data.edit_response(content: RESPONSE[1])
end
