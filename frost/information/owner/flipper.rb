# frozen_string_literal: true

module Owner
  # Flip a coin.
  def self.flip(data)
    if rand(1..100) >= 50
      data.edit_response(content: RESPONSE[3])
      return
    end

    data.edit_response(content: RESPONSE[4])
  end
end
