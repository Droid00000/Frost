# frozen_string_literal: true

require_relative 'src/frost/model/require'

bot = Discordrb::Bot.new(token: CONFIG['Discord']['TOKEN'], intents: 32_769, log_mode: :normal)

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
