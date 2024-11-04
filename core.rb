# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('..', __FILE__)

require 'require_all'
require 'discordrb'
require 'toml-rb'

require_all 'tags'
require_all 'pins'
require_all 'data'
require_all 'snow'
require_all 'voice'
require_all 'admin'
require_all 'emojis'
require_all 'events'
require_all 'boosters'
require_all 'affections'
require_all 'moderation'

bot = Discordrb::Bot.new(token: TOML['Discord']['TOKEN'], intents: 32897, log_mode: :debug)

bot.ready do
  bot.set_status(ACTIVITY[1], ACTIVITY[2])
end

bot.application_command(:shutdown) do |event|
  event.defer(ephemeral: true)
  if event.user.id == TOML['Discord']['OWNER']&.to_i
    event.edit_response(content: RESPONSE[19])
    bot.stop
  else
    event.edit_response(content: RESPONSE[18])
  end
end

bot.application_command(:eval) do |event|
  event.defer(ephemeral: event.options['ephemeral'])
  if event.user.id == TOML['Discord']['OWNER']&.to_i
    begin
      result = eval event.options['code']
      event.edit_response(content: "**Success:** ```#{event.options['code']}``` **Result:** ```#{result}```")
    rescue StandardError, SyntaxError => e
      event.edit_response(content: "**Error:** ```#{e.message}```")
    end
  else
    event.edit_response(content: RESPONSE[18])
  end
end

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
