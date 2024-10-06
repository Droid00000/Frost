# frozen_string_literal: true

require 'require_all'
require 'discordrb'
require 'toml-rb'

require_rel 'pins'
require_rel 'snow'
require_rel 'data'
require_rel 'admin'
require_rel 'events'
require_rel 'boosters'
require_rel 'affections'

bot = Discordrb::Bot.new(token: TOML['Discord']['TOKEN'], intents: [:servers], log_mode: :silent)

bot.ready do
  bot.update_status(ACTIVITY[50], ACTIVITY[60], ACTIVITY[70])
  Status.new(ACTIVITY[50], ACTIVITY[60], ACTIVITY[70])
end

bot.application_command(:shutdown) do |event|
  event.defer(ephemeral: true)
  if event.user.id == TOML['Discord']['OWNER']&.to_i
    event.edit_response(content: RESPONSE[511])
    bot.stop
  else
    event.edit_response(content: RESPONSE[510])
  end
end

bot.include! EventRoles
bot.include! BoosterPerks
bot.include! HugAffection
bot.include! NomAffection
bot.include! AdminCommands
bot.include! PokeAffection
bot.include! SnowballFights
bot.include! SleepAffection
bot.include! AngerAffection
bot.include! AutoPinArchiver
bot.include! ManualPinArchiver

bot.run
