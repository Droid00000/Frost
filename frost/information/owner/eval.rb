# frozen_string_literal: true

module Owner
  # Run some code on the bot.
  def self.code(data)
    unless data.user.id == CONFIG[:Discord][:OWNER]&.to_i
      data.respond(content: RESPONSE[1], ephemeral: true)
      return
    end

    # Respond initally so some requests don't timeout.
    data.respond(content: RESPONSE[2], ephemeral: true)

    begin
      code = eval(escape(data.value("code"))).inspect
    rescue StandardError, SyntaxError, RuntimeError => e
      data.edit_response(content: format(RESPONSE[4], e.message))
      return
    end

    code = if ("#{code}".length + 5) >= 2000
             file = Tempfile.new(["output", ".txt"])
             file if [file.write(code), file.rewind]
           else
             code
           end

    if code.is_a?(Tempfile)
      data.edit_response(attachments: [code])
    elsif "#{code}".empty?
      data.edit_response(content: RESPONSE[3])
    else
      data.edit_response(content: format(RESPONSE[4], code))
    end
  end
end
