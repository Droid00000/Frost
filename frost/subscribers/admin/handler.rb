# frozen_string_literal: true

module AdminCommands
  extend Discordrb::EventContainer

  application_command(:booster).group(:admin) do |group|
    group.subcommand(:add) do |event|
      event.defer(ephemeral: true)
      Boosters.add(event)
    end

    group.subcommand(:disable) do |event|
      event.defer(ephemeral: true)
      Boosters.disable(event)
    end

    group.subcommand(:enable) do |event|
      event.defer(ephemeral: true)
      Boosters.setup(event)
    end

    group.subcommand(:delete) do |event|
      event.defer(ephemeral: true)
      Boosters.delete(event)
    end

    group.subcommand(:unban) do |event|
      event.defer(ephemeral: true)
      Boosters.unban(event)
    end

    group.subcommand(:bans) do |event|
      event.defer(ephemeral: true)
      Boosters.bans(event)
    end

    group.subcommand(:ban) do |event|
      event.defer(ephemeral: true)
      Boosters.ban(event)
    end
  end
end
