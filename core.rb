# frozen_string_literal: true

$LOAD_PATH.unshift './src/frost/model'

Dir['./src/frost/model/*.rb'].each { |file| require file }

Dir['./src/frost/**/*.rb'].each { |file| require file unless file.include?('commands.rb') }

bot = Discordrb::Bot.new(token: CONFIG['Discord']['TOKEN'], intents: 32_769, log_mode: :silent)

bot.ready { rotating_status(bot) }

at_exit { bot.stop }

bot.include! EventRoles
bot.include! BoosterPerks
bot.include! EmojiCommands
bot.include! AdminCommands
bot.include! SnowballFights
bot.include! AutoPinArchiver
bot.include! AffectionCommands
bot.include! ManualPinArchiver
bot.include! ModerationCommands

bot.run
