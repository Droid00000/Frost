# frozen_string_literal: true

module Owner
  # Run some code on the bot.
  def self.experiment(data)
    begin
      code = eval(escape(data.value["code"]))
    rescue StandardError, SyntaxError => e
      data.send_message(content: format(RESPONSE[4], e.message))
      return
    end

    if code.length > Discordrb::CHARACTER_LIMIT
      Tempfile.open("output.txt") do |file|
        data.send_message(attachments: [file.write(code)])
        return
      end
    end

    if code.empty?
      data.send_message(content: RESPONSE[3])
    else
      data.send_message(content: format(RESPONSE[6], code))
    end
  end
end
