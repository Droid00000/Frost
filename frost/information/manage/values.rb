# frozen_string_literal: true

module Settings
  # Responses and fields for setting commands.
  RESPONSE = {
    1 => "These are the birthday settings for your server. Due to privacy reasons, the birthday announcement setting may not be respected. Birthday perks can be enabled, edited, and disabled with the </birthday admin:1354295411258429452> command group.",
    2 => "These are the enabled event roles for your server. Roles can be removed with the </component:1342292560378466346> command, and added with the  </component:1342292560378466346> command.",
    3 => "These are the booster settings for your server. Server boosters can be added, removed, banned, unbanned, and managed with the </booster admin:1354295411258429452> command group.",
    4 => "**About Me**\nI was made by droid00000. My code is open source and can be viewed [here](https://github.com/Droid00000/Frost)!\n\n",
    5 => "**Manager**\nBirthday perks were enabled in this server by **%s** on <t:%s:D>\n\n",
    6 => "**Hoist Role**\nAll newly created roles will be moved above this role: <@&%s>\n\n",
    7 => "**Birthday Role**\nMembers will be given this role on their birthday: <@&%s>\n\n",
    8 => "**Manager**\nBooster perks were enabled in this server by **%s** on <t:%s:D>\n\n",
    9 => "Hi! Welcome to my help page. Use the dropdown menu below to view a category.\n\n",
    10 => "**Channel**\nMembers will have their birthdays announced in this channel: <#%s>"
    11 => "**Stats**\nI'm on %s servers with a total of %s members and %s channels.",
    12 => "Server boosters may only use server emojis as their role icon.",
    13 => "Server boosters may use external emojis as their role icon.",
    14 => "-# Viewing %s out of %s roles",
    15 => "### Birthday Perks for %s",
    16 => "### Booster Perks for %s",
    17 => "### Event Roles for %s",
    18 => "### Main Menu"
  }.freeze

  # Application commands for general commands.
  COMMANDS = {
    1 => "`/info`"
  }.freeze

  # Transform a view into it's proper form.
  # @param bot [Discordrb::Interaction] The interaction.
  # @param view [Sequel::Dataset] The dataset to operate on.
  def manager(bot, view)
    [bot.bot.user(view[:manager]).name, view[:setup_at]]
  end

  # Resolve the select menu.
  def self.menu(data)
    case data.values[0]
    when "Pins"
      pins(data)
    when "Events"
      events(data)
    when "Boosters"
      boosters(data)
    when "Birthdays"
      birthdays(data)
    end
  end
end
