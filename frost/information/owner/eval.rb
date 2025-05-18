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
      # rubocop:disable Security/Eval
      code = eval(escape(data.value("code"))).inspect
      # rubocop:enable Security/Eval
    rescue StandardError, SyntaxError => e
      data.edit_response(content: format(RESPONSE[4], e.message))
      return
    end

    code = if (code.to_s.length + 5) >= 2000
             file = Tempfile.new(["output", ".txt"])
             # rubocop:disable Lint/LiteralAsCondition
             file if [file.write(code), file.rewind]
             # rubocop:enable Lint/LiteralAsCondition
           else
             code
           end

    if code.is_a?(Tempfile)
      data.edit_response(attachments: [code])
    elsif code.to_s.empty?
      data.edit_response(content: RESPONSE[3])
    else
      data.edit_response(content: format(RESPONSE[4], code))
    end
  end
end
