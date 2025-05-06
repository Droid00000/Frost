# frozen_string_literal: true

module Owner
  # Run some code on the bot.
  def self.code(data)
    unless data.user.id == CONFIG[:Discord][:OWNER]&.to_i
      data.edit_response(content: RESPONSE[1], ephemeral: true)
      return
    end

    begin
      code = eval(escape(data.value("code"))).inspect
    rescue StandardError, SyntaxError => e
      data.respond(content: format(RESPONSE[5], e.message), ephemeral: true)
      return
    end

    code = if ("#{code}".length + 5) >= Discordrb::CHARACTER_LIMIT
             file = Tempfile.new(["output", ".txt"])
             file if [file.write(code), file.rewind]
           else
             code
           end

    if code.is_a?(Tempfile)
      data.respond(attachments: [code], ephemeral: true)
    elsif "#{code}".empty?
      data.respond(content: RESPONSE[3], ephemeral: true)
    else
      data.respond(content: "``#{code}``", ephemeral: true)
    end
  end
end
