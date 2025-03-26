# frozen_string_literal: true

module General
  # Responses and fields for general commands.
  RESPONSE = {
    1 => "These are the enabled event roles for your server. Roles can be removed with the </component:1342292560378466346> command, and added with the  </component:1342292560378466346> command.",
    2 => "These are the booster settings for your server. Server boosters can be added, removed, banned, unbanned, and managed with the </booster admin:1354295411258429452> command group.",
    3 => "**About Me**\nI was made by droid00000. My code is open source and can be viewed [here](https://github.com/Droid00000/Frost)!\n\n",
    4 => "**Hoist Role**\nAll newly created roles will be moved above this role: <@&%s>\n\n",
    4 => "**Manager**\nBooster perks were enabled in this server by **%s** on <t:%s:D>\n\n",
    5 => "Hi! Welcome to my help page. Use the dropdown menu below to view a category.\n\n",
    6 => "**Stats**\nI'm on %s servers with a total of %s members and %s channels.",
    7 => "Server boosters may use any emoji on Discord as their role icon.",
    8 => "-# Viewing %s out of %s roles",
    9 => "**Next Chapter:** <t:%s:D>",
    10 => "### Booster Perks for %s",
    11 => "### Event Roles for %s",
    12 => "Invalid timezone.",
    13 => "### Main Menu"
  }.freeze

  # Application commands for general commands.
  COMMANDS = {
    1 => "`/next chapter when`",
    2 => "`/time`",
    3 => "`/info`"
  }.freeze

  # Format the stats string.
  def self.stats(bot)
    format(RESPONSE[3], bot.servers.values.size, bot.servers.values.map(&:member_count).sum.delimit, bot.servers.values.map(&:channels).flatten.size)
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
