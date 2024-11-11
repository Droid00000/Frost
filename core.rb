# frozen_string_literal: true

$LOAD_PATH.unshift File.join(File.expand_path(__dir__), 'src/frost')

require 'toml-rb'
require 'discordrb'
require 'require_all'

require_all 'src/frost/tags'
require_all 'src/frost/pins'
require_all 'src/frost/data'
require_all 'src/frost/snow'
require_all 'src/frost/voice'
require_all 'src/frost/admin'
require_all 'src/frost/emojis'
require_all 'src/frost/events'
require_all 'src/frost/boosters'
require_all 'src/frost/affections'
require_all 'src/frost/moderation'

bot = Discordrb::Bot.new(token: TOML['Discord']['TOKEN'], intents: 32_905, log_mode: :normal)

bot.ready { bot.custom_status(ACTIVITY[1], ACTIVITY[2]) }

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

at_exit { bot.stop }

bot.run
