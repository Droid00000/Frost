# frozen_string_literal: true

module Owner
  # Run some code on the bot.
  def self.evaluate(data)
    unless data.user.id == CONFIG[:Discord][:OWNER]&.to_i
      data.edit_response(content: RESPONSE[1])
      return
    end

    begin
      code = eval(escape(data.options["code"]))
    rescue StandardError, SyntaxError => e
      data.edit_response(content: format(RESPONSE[4], e.message))
      return
    end

    if code.length > Discordrb::CHARACTER_LIMIT
      Tempfile.open("output.txt") do |file|
        data.edit_response(attachments: [file.write(code)])
        return
      end
    end

    if code.empty?
      data.edit_response(content: RESPONSE[3])
    else
      data.edit_response(content: format(RESPONSE[6], code))
    end
  end
end
