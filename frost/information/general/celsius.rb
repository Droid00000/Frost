# frozen_string_literal: true

module General
  # Convert between C and F.
  def self.temperature(data)
    builder = lambda do |given|
      if data.options["output"] == 1
        "#{(given - 32) * 5 / 9} °C"
      else
        "#{given * 9 / 5 + 32} °F"
      end
    end

    given = data.options["input"].to_f

    data.edit_response(content: builder.call(given))
  end
end
