# frozen_string_literal: true

# Gets the release date of a chapter of a series.
def general_chapter(data)
  time = data.bot.channel(CONFIG[:Chapter][:CHANNEL]).name.delete_prefix("📖")
  time = Time.parse("#{time.sub('3PM GMT', '').strip} #{Time.now.year}")
  time = Time.new(time.year, time.month, time.day, "11", "05").to_i
  data.edit_response(content: format(RESPONSE[56], time))
end

# Cron job to update the release channel.
Rufus::Scheduler.new.cron "59 11 * * *" do
  options = Selenium::WebDriver::Firefox::Options.new
  options.add_argument("--headless")
  driver = Selenium::WebDriver.for :firefox, options: options
  driver.navigate.to CONFIG[:Chapter][:LINK]
  wait = Selenium::WebDriver::Wait.new(timeout: 10)
  wait.until { driver.find_element(:css, CONFIG[:Chapter][:ELEMENT]) }
  time = Date.parse(driver.find_element(:css, CONFIG[:Chapter][:ELEMENT]).text)
  name = "📖 #{time.strftime('%B')} #{time.day.ordinal} 3PM GMT"
  Discordrb::API::Server.channel_name(@bot.token, CONFIG[:Chapter][:CHANNEL], name, "update release date")
end
