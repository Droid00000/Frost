# frozen_string_literal: true

require 'discordrb'

$LOAD_PATH.unshift './src/frost'

Dir['./src/frost/**/*.rb'].each { |file| require file if !file.include?('commands.rb') }

bot = Discordrb::Bot.new(token: CONFIG['Discord']['TOKEN'], intents: 32_905, log_mode: :normal)

bot.ready { bot.custom_status(ACTIVITY[1], ACTIVITY[2]) }

at_exit { bot.stop }

bot.include! EventRoles
bot.include! TagCommands
bot.include! BoosterPerks
bot.include! HugAffection
bot.include! NomAffection
bot.include! VoiceCommands
bot.include! BonkAffection
bot.include! EmojiCommands
bot.include! AdminCommands
bot.include! PokeAffection
bot.include! SnowballFights
bot.include! PunchAffection
bot.include! SleepAffection
bot.include! AngerAffection
bot.include! AutoPinArchiver
bot.include! ManualPinArchiver
bot.include! ModerationCommands

bot.run
