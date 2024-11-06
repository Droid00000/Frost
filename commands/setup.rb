# frozen_string_literal: true

puts "Input your user ID."
USER_ID = gets.chomp

puts "Input your bot token."
BOT_TOKEN = gets.chomp

puts "Input an array of users who can use the punch command."
COMMANDS = gets.chomp

puts "Input an array of users who have contributed to the bot."
CONTRIBUTORS = gets.chomp

puts "Input your postgres database URI."
POSTGRES = gets.chomp

puts "Input your Lavalink node URI."
LAVALINK_URI = gets.chomp

puts "Input your Lavalink node password."
LAVALINK_PASSWORD = gets.chomp

File.open("testing.toml", "w") do |file|
  file.puts("[Discord]")
  file.puts("OWNER = #{USER_ID}")
  file.puts("TOKEN = \"Bot #{BOT_TOKEN}\"")
  file.puts("COMMANDS = #{COMMANDS}")
  file.puts("CONTRIBUTORS = #{CONTRIBUTORS}")
  file.puts('')
  file.puts("[Postgres]")
  file.puts("URL = \"postgres:// #{POSTGRES}\"")
  file.puts('')
  file.puts("[Lavalink]")
  file.puts("ADDRESS = \" #{LAVALINK_URI}\"")
  file.puts("PASSWORD = \" #{LAVALINK_PASSWORD}\"")
end
