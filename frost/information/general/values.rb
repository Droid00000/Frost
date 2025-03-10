# frozen_string_literal: true

module General
  # Responses and fields for general commands.
  RESPONSE = {
    1 => "These are the enabled event roles for your server. Roles can be removed with the </component:1342292560378466346> command, and added with the  </component:1342292560378466346> command."
    2 => "**About Me**\nI was made by droid00000. My code is open source and can be viewed [here](https://github.com/Droid00000/Frost)!\n\n",
    3 => "Hi! Welcome to my help page. Use the dropdown menu below to view a category.\n\n",
    4 => "**Stats**\nI'm on %s servers with a total of %s members and %s channels.",
    5 => "-# Viewing %s out of %s roles",
    6 => "**Next Chapter:** <t:%s:D>",
    7 =>  "### Event Roles for %s",
    8 => "Invalid timezone.",
    9 => "### Main Menu"
  }.freeze

  # Application commands for general commands.
  COMMANDS = {
    1 => "`/next chapter when`",
    2 => "`/time`",
    3 => "`/info`"
  }.freeze

  # Format the stats string.
  def self.stats(bot)
    format(RESPONSE[3], bot.bot.count_servers, bot.bot.count_members, bot.bot.count_channels)
  end

  # Resolve the select menu.
  def self.menu(data)
    case data.values
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
