# frozen_string_literal: true

module Owner
  # This is how we can handle logging.
  def self.logs(_data)
    return if File.file?("logs.txt")

    Discordrb::LOGGER.streams = [File.open("logs.txt", "w")]
  end
end
