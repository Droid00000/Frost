# frozen_string_literal: true

module Owner
  # Run some code on the bot.
  def self.code(data)
    begin
      code = eval(escape(data.value["code"]))
    rescue StandardError, SyntaxError => e
      data.send_message(content: format(RESPONSE[4], e.message))
      return
    end

    if (code.size + 6) > Discordrb::CHARACTER_LIMIT
      Tempfile.open("output.txt") do |file|
        return data.send_message(attachments: [file.write(code)])
      end
    end

    if code.empty?
      data.send_message(content: RESPONSE[3])
    else
      data.send_message(content: format(RESPONSE[6], code))
    end
  end
end
