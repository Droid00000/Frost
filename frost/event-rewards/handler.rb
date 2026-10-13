# frozen_string_literal: true

module EventRoleCommands
  extend Discordrb::EventContainer

  modal_submit(custom_id: "event_role_settings") do |event|
    event.defer(ephemeral: true)
    EventRoles.configure_submission(event)
  end

  select_menu(custom_id: "event_roles_locker") do |event|
    event.defer_update
    EventRoles.event_roles_locker_menu(event)
  end

  application_command(:event).subcommand(:roles) do |event|
    event.defer(ephemeral: true)
    EventRoles.event_roles_locker(event)
  end

  application_command(:event).group(:role) do |group|
    group.subcommand(:disable) do |event|
      event.defer(ephemeral: true)
      EventRoles.event_role_disable(event)
    end

    group.subcommand(:configure) do |event|
      EventRoles.event_role_configure(event)
    end
  end
end
