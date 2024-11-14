# frozen_string_literal: true

require 'net/http'
require 'json'

URL = "http://api.farmsense.net/v1/moonphases/?d=#{Time.now.to_i}"

puts JSON.parse((Net::HTTP.get(URI(URL))))[0]['Phase']

