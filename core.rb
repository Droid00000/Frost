# frozen_string_literal: true

$LOAD_PATH.unshift File.join(File.expand_path(__dir__), 'src/frost')

require 'require_all'
require 'discordrb'
require 'toml-rb'

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

bot = Discordrb::Bot.new(token: TOML['Discord']['TOKEN'], intents: 32905, compress_mode: :stream, log_mode: :debug)

bot.ready { bot.custom_status(ACTIVITY[1], ACTIVITY[2]) }

bot.application_command(:shutdown) do |event|
  event.defer(ephemeral: true)
  if event.user.id == TOML['Discord']['OWNER']&.to_i
    event.edit_response(content: RESPONSE[19])
    bot.stop
  else
    event.edit_response(content: RESPONSE[18])
  end
end

bot.application_command(:restart) do |event|
  event.defer(ephemeral: true)
  if event.user.id == TOML['Discord']['OWNER']&.to_i
    event.edit_response(content: RESPONSE[67])
    exec("bundle exec ruby core.rb")
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
