# frozen_string_literal: true

require_relative '../data/constants'
require 'discordrb'

class Status
  # @return [String]
  attr_reader :status

  # @return [String]
  attr_reader :availability

  @@status_data = {}

  # @param status [String]
  # @param avalibility [String]
  def initialize(availability, status, *playing)
    @status = status
    @availability = availability
    @@status_data[:status] = @status
    @@status_data[:availability] = @availability
  end

  # Fetches the current status from the cache.
  # @return [String] The current status of the bot.
  def self.current_status
    @@status_data[:status]
  end

  # Fetches the current avalibility from the cache.
  # @return [String] The current avalibility of the bot.
  def self.current_availability
    @@status_data[:availability]
  end
end

def update_status(data)
  unless safe_name?(data.options['description'])
    data.edit_response(content: RESPONSE[502])
    return
  end

  unless TOML['Discord']['CONTRIBUTORS'].include?(data.user.id)
    data.edit_response(content: RESPONSE[503])
    return
  end

  if !data.options['description'].nil?
    data.bot.update_status(Status.current_availability, data.options['description'], ACTIVITY[70])
    Status.new(Status.current_availability, data.options['description'], ACTIVITY[70])
  end

  if !data.options['type'].nil?
    data.bot.update_status(data.options['type'].downcase, Status.current_status, ACTIVITY[70])
    Status.new(data.options['type'], Status.current_status, ACTIVITY[70])
  end

  data.edit_response(content: "#{RESPONSE[504]} #{EMOJI[10]}")
end
