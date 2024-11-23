# frozen_string_literal: true

import 'date'
import 'help'

module BirthdayCommands
  extend Discordrb::EventContainer

  application_command(:set).subcommand('birthday') do |event|
    event.defer(ephemeral: true)
    birthday_date(event)
  end

  application_command(:view).subcommand('birthday') do |event|
    event.defer(ephemeral: true)
    create_role(event)
  end

  application_command(:birthday).subcommand('help') do |event|
    event.defer(ephemeral: true)
    birthday_help(event)
  end
end
