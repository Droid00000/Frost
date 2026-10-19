# frozen_string_literal: true

module EventRoles
  # View a user's event roles.
  def self.event_roles_locker(event)
    bot_max = event.guild.current_bot.highest_role

    roles = event.guild.roles.select do |role|
      next if role > bot_max

      BOT.event_roles_cache.fetch_role(role)&.user?(event.user)
    end

    if roles.empty?
      event.edit_response(content: REPLY.NO_EVENT_ROLES_AVAILABLE)
      return
    end

    roles.sort_by!(&:id)
    guild_roles = roles.first(5)
    single_page = roles.length <= 5
    next_role_id = guild_roles.last&.id
    before_role_id = guild_roles.first&.id

    guild_roles.sort_by! do |role|
      role.name.chars.sum { GG_SANS_WIDTHS[it] || 1.2 }
    end

    # IS_COMPONENTS_V2 message flag.
    flags = 1 << 15

    event.edit_response(flags: flags) do |_, ui|
      container = add_roles_ui(ui, guild_roles, event.user)

      menu = {
        max_values: 1,
        placeholder: "Navigation Menu",
        custom_id: "event_roles_locker"
      }

      container.row do |row|
        row.select_menu(**menu, disabled: single_page) do |menu|
          if before_role_id && roles.any? { it.id < before_role_id }
            menu.option(
              label: "Back",
              emoji: 1_557_209_200_462_135_296,
              value: "role_back_id=#{before_role_id}",
              description: "Go back by a single page."
            )
          end

          if next_role_id && roles.any? { it.id > next_role_id }
            menu.option(
              label: "Forward",
              emoji: 1_557_209_202_211_168_318,
              value: "role_next_id=#{next_role_id}",
              description: "Go forward by a single page."
            )
          end
        end
      end
    end
  end

  # View the next page of a user's event roles.
  def self.event_roles_locker_menu(event)
    bot_max = event.guild.current_bot.highest_role

    roles = event.guild.roles.select do |role|
      next if role > bot_max

      BOT.event_roles_cache.fetch_role(role)&.user?(event.user)
    end

    if roles.empty?
      event.send_message(
        content: REPLY.NO_EVENT_ROLES_AVAILABLE, ephemeral: true
      )

      return
    end

    roles.sort_by!(&:id)
    value = event.values[0]
    role_id = value[(value.index("=") + 1)..].to_i

    guild_roles = if value.start_with?("role_back_id")
                    roles.select { |role| role.id < role_id }.last(5)
                  else
                    roles.select { |role| role.id > role_id }.first(5)
                  end

    next_role_id = guild_roles.last&.id
    before_role_id = guild_roles.first&.id

    guild_roles.sort_by! do |role|
      role.name.chars.sum { GG_SANS_WIDTHS[it] || 1.2 }
    end

    # EPHEMERAL and IS_COMPONENTS_V2 message flags.
    flags = (1 << 6) | (1 << 15)

    event.edit_response(flags: flags) do |_, ui|
      container = add_roles_ui(ui, guild_roles, event.user)

      menu = {
        max_values: 1,
        placeholder: "Navigation Menu",
        custom_id: "event_roles_locker"
      }

      container.row do |row|
        row.select_menu(**menu, disabled: false) do |menu|
          if before_role_id && roles.any? { it.id < before_role_id }
            menu.option(
              label: "Back",
              emoji: 1_557_209_200_462_135_296,
              value: "role_back_id=#{before_role_id}",
              description: "Go back by a single page."
            )
          end

          if next_role_id && roles.any? { it.id > next_role_id }
            menu.option(
              label: "Forward",
              emoji: 1_557_209_202_211_168_318,
              value: "role_next_id=#{next_role_id}",
              description: "Go forward by a single page."
            )
          end
        end
      end
    end
  end
end
