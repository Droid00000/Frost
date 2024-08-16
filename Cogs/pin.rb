require 'discordrb'

require 'sqlite3'

require 'dotenv'

require 'time'

Dotenv.load

bot = Discordrb::Bot.new(token: ENV['BOT_TOKEN'], intents: [:servers, :server_messages])

db = SQLite3::Database.new("server_settings.db")
db.execute_batch <<-SQL
CREATE TABLE IF NOT EXISTS servers (server_id INTEGER NOT NULL PRIMARY KEY, archive_channel_id INTEGER NOT NULL UNIQUE);
SQL
db.close


bot.register_application_command(:setup, 'Setup the pin-archiver functionality.', server_id: ENV['SLASH_COMMAND_SERVER_ID']) do |cmd|
cmd.channel('channel', 'Which channel should archived pins be sent to?', required: true)    
end

bot.application_command(:setup) do |event|
user = event.user
perm_check = user.permission?(:manage_server, channel = nil)
if perm_check == false
event.respond(content: "You must have the ``manage_server`` permission to use this command.", ephemeral: true)  
next
end    
    
db = SQLite3::Database.new("server_settings.db")
origin = event.server.id
channel = event.options['channel']
db.execute("INSERT INTO servers (server_id, archive_channel_id) VALUES (?, ?)", ["#{origin}", "#{channel}"])
event.respond(content: "Successfully setup the pin archiver!", ephemeral: true)
rescue SQLite3::ConstraintException => e
db.execute("UPDATE servers SET archive_channel_id = ? WHERE server_id = ?", ["#{channel}", "#{origin}"])
event.respond(content: "Successfully updated settings!", ephemeral: true)     
end

bot.register_application_command(:archive, 'Archives pins in a specified channel.', server_id: ENV['SLASH_COMMAND_SERVER_ID']) do |cmd|
cmd.channel('channel', 'Which channel needs to have its pins archived?', required: true)    
end

bot.application_command(:archive) do |event|
db = SQLite3::Database.new("server_settings.db")    
client_server_id = event.server.id   
user = event.user
perm_check = user.permission?(:manage_messages, channel = nil)
if perm_check == false
event.respond 'You need to have the ``manage messages`` permission to use this command.'
next
end    

event.defer
audit_channel = event.options['channel']
resolve_audit = bot.channel(audit_channel)
current_pins = resolve_audit.pins
if current_pins.count >= 49
second_recent = current_pins[1]
username = second_recent.author.username
msg_content = second_recent.content
msg_link = second_recent.link
msg_id = second_recent.id
avatar = second_recent.author.avatar_url(format = "png")
time_raw = second_recent.timestamp.to_s
time_var = Time.parse(time_raw)
time_unix = time_var.to_i
human_time_1 = Time.at(time_unix)
time = human_time_1.strftime('%m/%d/%Y %H:%M %p')
db.results_as_hash = true
db.execute( "select * from servers where server_id = ?", ["#{client_server_id}"]) do |row|
archive_channel = row['archive_channel_id']
channel = bot.channel(archive_channel)
channel.send_embed do |embed|
embed.colour = 0x8da99b
embed.description = "#{msg_content}"             
embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "#{username}", url: "#{msg_link}", icon_url: "#{avatar}")
embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{msg_id} • #{time}")              
embed.add_field(name: "Source", value: "[Jump!](#{msg_link})")
end

second_recent.unpin
event.edit_response(content: "Archived one pin by **#{username}**.")  
end
end
end    


bot.register_application_command(:shutdown, 'Safely disconnects the bot from the gateway.', server_id: ENV['SLASH_COMMAND_SERVER_ID']) do |cmd|
end

bot.application_command(:shutdown) do |event|
break unless event.user.id == 673658900435697665
event.respond(content: "The bot has powered off.", ephemeral: true) 
bot.stop 
end


bot.run