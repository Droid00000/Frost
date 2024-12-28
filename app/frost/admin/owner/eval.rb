# frozen_string_literal: true

# Allows us to execute arbitrary code on the current proccess.
def owner_eval(data)
  if data.user.id == CONFIG["Discord"]["OWNER"]&.to_i
    begin
      result = eval data.options["code"]
      data.edit_response(content: "**Success:** ```#{data.options['code']}``` **Result:** ```#{result}```")
    rescue StandardError, SyntaxError => e
      data.edit_response(content: "**Error:** ```#{e.message}```")
    end
  else
    data.edit_response(content: RESPONSE[18])
  end
end
