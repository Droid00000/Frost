# frozen_string_literal: true

require 'json'
require 'net/http'

def moon_phase(data)
  data.edit_response(content: (MOON[JSON.parse(Net::HTTP.get(URI("http://api.farmsense.net/v1/moonphases/?d=#{Time.now.to_i}")))[0]['Phase']]).to_s)
end
