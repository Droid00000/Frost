# frozen_string_literal: true

Rufus::Scheduler.singleton.cron "19 15 * * *" do
  # Setup selenium.
  options = Selenium::WebDriver::Firefox::Options.new
  options.add_argument("--headless")
  driver = Selenium::WebDriver.for(:firefox, options: options)

  # Fetch webpage.
  config = BOT.config.chapter_info
  driver.navigate.to(config.website_url)
  wait = Selenium::WebDriver::Wait.new(timeout: 30)
  wait.until { driver.find_element(:css, config.website_css) }

  # Find target CSS.
  date_element = driver.find_element(:css, config.website_css)

  # Quit selenium once done.
  driver.quit

  # Parse the target CSS text.
  date = Date.parse(date_element.text.split("\n")[1])
  ordinal_date_day = Frost::Utilities.ordinal(date.day)
  new_name = "📖 #{date.strftime('%B')} #{ordinal_date_day} 3PM GMT"

  # Update the channel name on Discord.
  config.channel&.modify(name: new_name, reason: "Update Release Date")
end
