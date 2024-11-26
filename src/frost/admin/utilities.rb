# frozen_string_literal: true

# Turns the bot off and kills the Gateway connection.
def shutdown_command(data)
  if data.user.id == CONFIG['Discord']['OWNER']&.to_i
    data.edit_response(content: RESPONSE[19])
    data.bot.stop
  else
    data.edit_response(content: RESPONSE[18])
  end
end

# Restarts the Gateway connection.
def restart_command(data)
  if data.user.id == CONFIG['Discord']['OWNER']&.to_i
    data.edit_response(content: RESPONSE[50])
    exec('bundle exec ruby core.rb')
  else
    data.edit_response(content: RESPONSE[18])
  end
end

# Allows us to execute arbitrary code on the current proccess.
def eval_command(data)
  if data.user.id == CONFIG['Discord']['OWNER']&.to_i
    begin
      result = eval data.options['code']
      data.edit_response(content: "**Success:** ```#{data.options['code']}``` **Result:** ```#{result}```")
    rescue StandardError, SyntaxError => e
      data.edit_response(content: "**Error:** ```#{e.message}```")
    end
  else
    data.edit_response(content: RESPONSE[18])
  end
end

# Gets the release date of a chapter of a series.
def next_chapter_date(data)
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  driver = Selenium::WebDriver.for :chrome, options: options
  driver.navigate.to CONFIG['Chapter']['LINK']
  sleep(6)
  time = driver.find_element(:css, CONFIG['Chapter']['ELEMENT'])
  data.edit_response(content: RESPONSE[56] % DateTime.parse(time.text).to_time.to_i) do |builder, components|
    components.row do |buttons|
      buttons.button(emoji: 1310804270240628816, custom_id: 'chapter', style: :danger, label: 'Why?')
    end
  end
end

# Responds to the button interaction for the new chapter command.
def chapter_reason(data)
  data.send_message(content: "#{RESPONSE[55]} #{EMOJI[6]}", ephemeral: true)
end

# Rotates the bots status everyday at 1AM.
def rotating_status(bot)
  Rufus::Scheduler.new.cron '0 1 * * *' do
    bot.custom_status(nil, STATUS.to_a.sample.last)
  end
end
