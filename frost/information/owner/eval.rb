# frozen_string_literal: true

module Owner
  # Run some code on the current ruby process.
  def self.code(data)
    unless data.user.id == CONFIG[:Discord][:OWNER]&.to_i
      data.respond(content: RESPONSE[2], ephemeral: true)
      return
    end

    # Respond initally so some requests don't timeout.
    data.respond(content: RESPONSE[4], ephemeral: true)

    begin
      # rubocop:disable Security/Eval
      code = eval(escape(data.value("code"))).inspect
      # rubocop:enable Security/Eval
    rescue StandardError, SyntaxError => e
      code = "#{e.backtrace.join("\n")}\n#{e.message}"
    end

    code = if (code.to_s.length + 5) >= 2000
             file = Tempfile.new(["output", ".rb"])
             # rubocop:disable Lint/LiteralAsCondition
             file if [file.write(code), file.rewind]
             # rubocop:enable Lint/LiteralAsCondition
           else
             code
           end

    if code.is_a?(Tempfile)
      data.edit_response(attachments: [code])
    elsif code.to_s.empty?
      data.edit_response(content: RESPONSE[5])
    else
      data.edit_response(content: format(RESPONSE[7], code))
    end
  end
end
