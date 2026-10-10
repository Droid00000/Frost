# frozsen_string_literal: true

module EventRoleCommands
  extend Discordrb::EventContainer

  application_command(:event).group(:role) do |group|
    group.subcommand(:remove) do |event|
      event.defer(ephemeral: true)
      EventRoles.remove_event_role(event)
    end

    group.subcommand(:add) do |event|
      event.defer(ephemeral: true)
      EventRoles.add_event_role(event)
    end
  end

end
