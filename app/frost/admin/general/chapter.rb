# frozen_string_literal: true

# Gets the release date of a chapter of a series.
def general_chapter(data)
  options = Selenium::WebDriver::Firefox::Options.new
  options.add_argument("--headless")
  driver = Selenium::WebDriver.for :firefox, options: options
  driver.navigate.to CONFIG["Chapter"]["LINK"]
  sleep(6)
  time = driver.find_element(:css, CONFIG["Chapter"]["ELEMENT"])
  data.edit_response(content: format(RESPONSE[56], DateTime.parse(time.text).to_time.utc.to_i))
end
