# frozen_string_literal: true

module General
  # Gets the release date of a chapter of a series.
  def self.chapter(data)
    time = Time.parse(data.bot.channel(CONFIG[:Chapter][:CHANNEL]).name)
    data.edit_response(content: Discordrb.timestamp(time, :short_datetime))
  end

  # Function to the find the date of the chapter.
  def self.find_chapter
    options = Selenium::WebDriver::Firefox::Options.new
    options.add_argument("--headless")
    driver = Selenium::WebDriver.for :firefox, options: options
    driver.navigate.to CONFIG[:Chapter][:LINK]
    wait = Selenium::WebDriver::Wait.new(timeout: 20)
    wait.until { driver.find_element(:css, CONFIG[:Chapter][:ELEMENT]) }
    time = Date.parse(driver.find_element(:css, CONFIG[:Chapter][:ELEMENT]).text)
    data = ["📖 #{time.strftime('%B')} #{time.day.ordinal} 3PM GMT", driver.quit]
    Discordrb::API.request(
      :channels_cid,
      CONFIG[:Chapter][:CHANNEL],
      :patch,
      "#{Discordrb::API.api_base}/channels/#{CONFIG[:Chapter][:CHANNEL]}",
      { name: data.first }.to_json,
      Authorization: BOT.token,
      content_type: :json,
      "X-Audit-Log-Reason": "Release Date"
    )
  end
end

# Cron job to update the release channel.
Rufus::Scheduler.singleton.cron "19 15 * * *" do
  General.find_chapter
end
