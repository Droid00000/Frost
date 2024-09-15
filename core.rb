# frozen_string_literal: true

require 'require_all'
require 'discordrb'
require 'toml-rb'

require_rel 'pins'
require_rel 'tags'
require_rel 'data'
require_rel 'admin'
require_rel 'boosters'
require_rel 'affections'

TOML = TomlRB.load_file('config.toml')

bot = Discordrb::Bot.new(token: TOML['Discord']['RAW_TOKEN'], intents: %i[servers server_messages])

bot.ready do
  bot.update_status(ACTIVITY[50], ACTIVITY[60], ACTIVITY[70])
end

bot.application_command(:shutdown) do |event|
  break unless event.user.id == TOML['Discord']['OWNER']

  event.respond(content: 'The bot has powered off.', ephemeral: true)
  bot.stop
end

bot.include! BoosterPerks
bot.include! AngerAffection
bot.include! HugAffection
bot.include! PokeAffection
bot.include! NomAffection
bot.include! SleepAffection
bot.include! AutoPinArchiver
bot.include! ManualPinArchiver

bot.run
