# frozen_string_literal: true

$LOAD_PATH.unshift './src/frost/model'

Dir['./src/frost/model/*.rb'].each { |file| require file }

Dir['./src/frost/**/*.rb'].each { |file| require file unless file.include?('commands.rb') }

bot = Discordrb::Bot.new(token: CONFIG['Discord']['TOKEN'], intents: 32_905, log_mode: :normal)

bot.ready { bot.custom_status(ACTIVITY[1], ACTIVITY[2]) }

at_exit { bot.stop }

bot.include! EventRoles
bot.include! BoosterPerks
bot.include! HugAffection
bot.include! NomAffection
bot.include! BonkAffection
bot.include! EmojiCommands
bot.include! AdminCommands
bot.include! PokeAffection
bot.include! SnowballFights
bot.include! PunchAffection
bot.include! SleepAffection
bot.include! AngerAffection
bot.include! AutoPinArchiver
bot.include! BirthdayCommands
bot.include! ManualPinArchiver
bot.include! ModerationCommands

bot.run
