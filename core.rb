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

BOT = Discordrb::Bot.new(token: TOML['Discord']['RAW_TOKEN'], intents: [:servers], log_mode: :silent)

BOT.ready do
  BOT.update_status(ACTIVITY[50], ACTIVITY[60], ACTIVITY[70])
  Status.new(ACTIVITY[50], ACTIVITY[60], ACTIVITY[70])
end

BOT.application_command(:shutdown) do |event|
  break unless event.user.id == TOML['Discord']['OWNER']&.to_i

  event.respond(content: 'The bot has powered off.', ephemeral: true)
  BOT.stop
end

BOT.include! EventRoles
BOT.include! BoosterPerks
BOT.include! HugAffection
BOT.include! NomAffection
BOT.include! AdminCommands
BOT.include! PokeAffection
BOT.include! SnowballFights
BOT.include! SleepAffection
BOT.include! AngerAffection
BOT.include! AutoPinArchiver
BOT.include! ManualPinArchiver

BOT.run
