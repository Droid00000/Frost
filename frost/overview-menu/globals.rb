# frozen_string_literal: true

module Frost::Overview
  # Interaction responses.
  REPLY = Frost::Utilities.table(
    FEATURE_NOT_ENABLED: "This feature has not been enabled.",
    BOOSTER_ROLE_DELETED: "This server's booster role has been deleted.",
    MISSING_PERMISSIONS: "You need to have the `manage roles` permission to do this."
  )

  # Content for different pages.
  ELEMENTS = Frost::Utilities.table(
    MAIN_MENU_GREETING: "Hi! Welcome to my help page. Use the dropdown menu below to view a category.\n\n**About Me**\nI was made by droid00000. My code is open source and can be viewed [here!](https://github.com/Droid00000/Frost)",
    STATISTICS: "**Stats**\nI'm on %s servers with a total of %s members and %s channels.",
    BOOSTERS_MENU_OVERVIEW: "These are the booster settings for your server. Server boosters can be added, removed, banned, and unbanned with the **/booster admin** command group.",
    BOOSTERS_MENU_ANY_ICON: "**Icon**\nServer boosters may use any custom or unicode emoji as their role icon.",
    BOOSTERS_MENU_MANAGER_INFO: "**Manager**\nBooster perks were enabled in this server by **%s** on <t:%s:D>\n\n",
    BOOSTERS_MENU_HOIST_ROLE_INFO: "**Hoist Role**\nAll newly created roles will be moved above this role: <@&%s>\n\n",
    BOOSTERS_MENU_NO_EXTERNAL_ICONS: "**Icon**\nServer boosters may only use server and unicode emojis as their role icon."
  )

  # Add a select menu to a container for an interaction initiated by a basic user.
  def self.basic_menu(container, event)
    base_state = {
      min_values: 1,
      custom_id: "settings",
      placeholder: "Pick a category...",
      disabled: !(event.guild_integration? && event.user.can_manage_roles?)
    }

    container.row do |action_row|
      action_row.select_menu(**base_state) do |menu|
        menu.option(
          value: "Birthdays",
          label: "Birthdays",
          emoji: "733787070123737109",
          description: "Settings for server birthdays."
        )

        menu.option(
          value: "Boosters",
          label: "Boosters",
          emoji: "1320971944627146752",
          description: "Settings for server boosters."
        )
      end
    end
  end

  # Add a select menu to a container for an interaction initiated by the bot owner.
  def self.owner_menu(container, event)
    base_state = {
      min_values: 1,
      custom_id: "settings",
      placeholder: "Pick a category..."
    }

    container.row do |action_row|
      action_row.select_menu(**base_state) do |menu|
        if event.guild_integration?
          menu.option(
            value: "Birthdays",
            label: "Birthdays",
            emoji: "733787070123737109",
            description: "Settings for server birthdays."
          )

          menu.option(
            value: "Boosters",
            label: "Boosters",
            emoji: "1320971944627146752",
            description: "Settings for server boosters."
          )
        end

        menu.option(
          value: "Owner",
          label: "Settings",
          emoji: "1449277904147054725",
          description: "Settings for the application."
        )
      end
    end
  end

  # Generate text containing information about the bot's statistics and maintainer.
  def self.overview_text(bot)
    statistics = format(
      ELEMENTS.STATISTICS,
      Frost::Utilities.delimit(bot.guilds.size),
      Frost::Utilities.delimit(bot.guilds.sum { |_, guild| guild.member_count }),
      Frost::Utilities.delimit(bot.guilds.sum { |_, guild| guild.channels.size })
    )

    "#{ELEMENTS.MAIN_MENU_GREETING}\n\n#{statistics}"
  end
end
