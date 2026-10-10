# frozsen_string_literal: true

module EventRoleCommands
  extend Discordrb::EventContainer

  application_command(:event).group(:role) do |group|
    group.subcommand(:remove) do |event|
      event.defer(ephemeral: true)
      EventRoles.event_role_remove(event)
    end

    group.subcommand(:add) do |event|
      event.defer(ephemeral: true)
      EventRoles.event_role_add(event)
    end
  end
end
