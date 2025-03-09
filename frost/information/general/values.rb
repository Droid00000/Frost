# frozen_string_literal: true

module General
  # Responses and fields for general commands.
  RESPONSE = {
    1 => "**About Me**\nI was made by droid00000. My code is open source and can be viewed [here](https://github.com/Droid00000/Frost)!\n\n",
    2 => "Hi! Welcome to my help page. Use the dropdown menu below to view a category.\n\n",
    3 => "**Stats**\nI'm on %s servers with a total of %s members and %s channels.",
    4 => "**Next Chapter:** <t:%s:D>",
    5 => "Invalid timezone.",
    6 => "### Main Menu"
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
end
