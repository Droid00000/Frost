# frozen_string_literal: true

module EventRoleCommands
  extend Discordrb::EventContainer

  modal_submit(custom_id: "event_role_settings") do |event|
    event.defer(ephemeral: true)
    EventRoles.configure_submission(event)
  end

  application_command(:event).group(:role) do |group|
    group.subcommand(:remove) do |event|
      event.defer(ephemeral: true)
      EventRoles.event_role_remove(event)
    end

    group.subcommand(:add) do |event|
      event.defer(ephemeral: true)
      EventRoles.event_role_add(event)
    end

    group.subcommand(:disable) do |event|
      event.defer(ephemeral: true)
      EventRoles.event_role_disable(event)
    end

    group.subcommand(:configure) do |event|
      EventRoles.event_role_configure(event)
    end
  end
end
