# frozen_string_literal: true

module Owner
  # Run some code on the bot.
  def self.evaluate(data)
    unless data.user.id == CONFIG[:Discord][:OWNER]&.to_i
      data.edit_response(content: RESPONSE[18])
      return
    end

    begin
      result = eval(data.options["code"])
      data.edit_response(content: "**Success:** ```#{data.options['code']}``` **Result:** ```#{result}```")
    rescue StandardError, SyntaxError => e
      data.edit_response(content: "**Error:** ```#{e.message}```")
    end
  end
end
