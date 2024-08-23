require 'discordrb'

require 'sqlite3'

require 'down'

require 'tempfile'

require 'dotenv'

require 'rufus-scheduler'

Dotenv.load

bot = Discordrb::Bot.new(token: ENV['BOT_TOKEN'], intents: [:server_members])

db = SQLite3::Database.new("settings.db")

db.execute_batch <<-SQL
CREATE TABLE IF NOT EXISTS boosters

(client_user_id INTEGER NOT NULL, role_id INTEGER NOT NULL, server_boost_origin INTEGER NOT NULL, UNIQUE(client_user_id, server_boost_origin));

CREATE TABLE IF NOT EXISTS boost_servers (server_id INTEGER NOT NULL PRIMARY KEY, hoist_role_id INTEGER NOT NULL UNIQUE);
SQL

db.close

def remove_hashtag(string)
string.start_with?('#') ? string[1..-1] : string
end

def extract_emoji_id(string)
match = string.match(/:(\d+)>$/)
match ? match[1] : nil
end

def check_boosting_status(bot, server_id, member_id, role_id)
server = bot.server(server_id)
return unless server 

member = server.member(member_id) 
return unless member 


unless member.boosting?
role = server.role(role_id) 
if role
role.delete
puts "Role #{role_id} deleted."
return true

end
end
false
end


bot.register_application_command(:booster, 'Booster perks', server_id: ENV['SLASH_COMMAND_SERVER_ID']) do |cmd|
  cmd.subcommand_group(:role, 'Booster roles!') do |group|
    group.subcommand('claim', 'Claim your custom booster role!') do |sub|
      sub.string('name', 'Provide a name for your role.', required: true)
      sub.string('color', 'Provide a HEX color for your role.', required: true)
      sub.string('icon', 'Provide an emoji to serve as your role icon.', required: false)
    end

    group.subcommand('edit', 'Edit your custom booster role!') do |sub|
      sub.string('name', 'Provide a name for your role.', required: false)
      sub.string('color', 'Provide a HEX color for your role.', required: false)
      sub.string('icon', 'Provide an emoji to serve as your role icon.', required: false)
    end 

    group.subcommand('delete', 'Delete your custom booster role.') do |sub|
    end
    
    group.subcommand('setup', 'Setup booster perks for your server.') do |sub|
    sub.role('position', 'Which role should all booster roles be placed above?')   
    end

    group.subcommand('help', 'Open the booster perks help menu.') do |sub|
    end  
    
  end
end



bot.application_command(:booster).group(:role) do |group|
group.subcommand('setup') do |event|
user = event.user
perm_check = user.permission?(:administrator, channel = nil)
if perm_check == false
event.respond(content: "Only an administrator can use this command.", ephemeral: true)  
next
end


db = SQLite3::Database.new("settings.db")    
role = event.options['position']
origin = event.server.id
if role.nil?
db.execute( "delete from boost_servers where server_id = ?", ["#{origin}"])
event.respond(content: 'Succesfully reset your server settings.', ephemeral: true)
next
end

db.execute("INSERT INTO boost_servers (server_id, hoist_role_id) VALUES (?, ?)", ["#{origin}", "#{role}"])  
event.respond(content: 'Succesfully setup the bot!', ephemeral: true)
rescue SQLite3::ConstraintException => e
event.respond(content: "Successfully updated your server settings!", ephemeral: true)
db.execute("UPDATE boost_servers SET hoist_role_id = ? WHERE server_id = ?", ["#{role}", "#{origin}"])  
end    



group.subcommand('help') do |event|

event.respond(ephemeral: true) do |builder|
builder.add_embed do |embed|
embed.title = "**Commands**"  
embed.colour = 0xd4f0ff  
embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "https://cdn.discordapp.com/avatars/1268769768920580156/1551613008086970c244a81d043d354e?size=1024")
embed.add_field(name: "``/booster role claim``", value: "Creates your custom role. Your role name must contain any foul language. Simply put a custom emoji as you normally would in the icon option.")
embed.add_field(name: "``/booster role edit``", value: "Lets you edit your custom role. All parameters are optional.")
embed.add_field(name: "``/booster role delete``", value: "Deletes your custom role. You can make a new role at any time provided you keep boosting the server.")
embed.add_field(name: "``/booster role setup``", value: "Sets up the bot for use on your server.")
embed.add_field(name: "``/booster role help``", value: "Shows some info on how to use the bot.")
embed.add_field(name: "``/about``", value: "Shows some information about the bot and its owner.")
end
end
end     



  group.subcommand('claim') do |event|
    command_user = event.user
    client_id = command_user.id
    client_server_id = event.server.id
    reason_string = "Server booster claimed role."
    name_input = event.options['name']
    if name_input.match(/fag|f@g|bitch|b1tch|faggot|whore|wh0re|tranny|tr@nny|nigger|nigga|faggot|nibba|n1g|n1gger|nigaboo|n1gga|n i g g e r|n i g g a|@everyone|r34|porn|hentai|sakimichan|patron only|pornhub|.gg|xxxvideos|xvideos|retard|retarded|porno|deepfake|erection|thirst trap|erection|khyleri|dyke|anus|anal|blowjob|boner|cum|chink|chinky|paki|futanari|titjob|boobjob|scat|jizz|gangbang|chingchong|ziggaboo|mexcrement|kill yourself|kys|clit|orgasm|semen|foreskin|cock|ahegao|pedophile|pedophille|autist|pedos|gook|negro|rape|raper|rapist|slut|fellatio|cuck|.com|.org|.net|pussy|penis|uterus|cnc|bdsm|cunt|kink|kinky|discord.gg|join my server|thighs|th1ghs/i)
    event.respond(content: "You're not allowed to use this word in your role name.") 
    next
    end

    db = SQLite3::Database.new("settings.db")
    db.results_as_hash = true
    data = db.execute( "select * from boost_servers where server_id = ?", ["#{client_server_id}"])
    if data.empty?
    event.respond(content: "This server hasn't setup booster perks.", ephemeral: true)
    next
    end  

    if event.user.boosting? == false
    event.respond(content: 'Please boost the server to claim your role.', ephemeral: true)
    next
    end

    color_input = event.options['color']
    color_space_filter = color_input.strip
    hashtag_checked = remove_hashtag("#{color_space_filter}")
    color_converted = Discordrb::ColourRGB.new("#{hashtag_checked}")
    custom_booster_role = event.server.create_role(name: name_input, colour: color_converted, hoist: false, mentionable: false, permissions: 0, reason: reason_string)
    db.execute("SELECT * FROM boost_servers WHERE server_id = ?", client_server_id) do |row|
    position_role = row['hoist_role_id']    
    custom_booster_role.sort_above(position_role)
    command_user.add_role(custom_booster_role, reason = reason_string)

    raw_id = command_user
    client_id = command_user.id
    booster_role_id = custom_booster_role.id
    db.execute("INSERT INTO boosters (client_user_id, role_id, server_boost_origin) VALUES (?, ?, ?)", ["#{client_id}", "#{booster_role_id}", "#{client_server_id}"])
      


    
    emoji_icon = event.options['icon']
    unless emoji_icon.nil?
    emoji_number_id = extract_emoji_id(emoji_icon)
    emoji_cdn_url = "https://cdn.discordapp.com/emojis/#{emoji_number_id}.png"
    tempfile = Down.download("#{emoji_cdn_url}")
    location = tempfile.path
    custom_booster_role.icon = File.open("/private#{location}", 'rb')
    tempfile.unlink
    end

    event.respond(content: 'Your role has been successfully claimed. You may edit your role using the ``/booster role edit`` command. <:AnyaPeek_Enzo:1276327731113627679>', ephemeral: true)
    rescue Discordrb::Errors::NoPermission => e
    event.respond(content: 'Your role has been successfully claimed. You may edit your role using the ``/booster role edit`` command. <:AnyaPeek_Enzo:1276327731113627679>', ephemeral: true)
    rescue SQLite3::ConstraintException => e
    event.respond(content: "You've already claimed your custom role.", ephemeral: true)  
    custom_booster_role.delete  
    end








  group.subcommand(:edit) do |event|  
  command_user = event.user
  client_id = command_user.id
  server_id = event.server.id  
  edit_name_input = event.options['name']
  edit_color_input = event.options['color']
  edit_icon = event.options['icon']  
  unless edit_name_input.nil?
  if edit_name_input.match(/fag|f@g|bitch|b1tch|faggot|whore|wh0re|tranny|tr@nny|nigger|nigga|faggot|nibba|n1g|n1gger|nigaboo|n1gga|n i g g e r|n i g g a|@everyone|r34|porn|hentai|sakimichan|patron only|pornhub|.gg|xxxvideos|xvideos|retard|retarded|porno|deepfake|erection|thirst trap|erection|khyleri|dyke|anus|anal|blowjob|boner|cum|chink|chinky|paki|futanari|titjob|boobjob|scat|jizz|gangbang|chingchong|ziggaboo|mexcrement|kill yourself|kys|clit|orgasm|semen|foreskin|cock|ahegao|pedophile|pedophille|autist|pedos|gook|negro|rape|raper|rapist|slut|fellatio|cuck|.com|.org|.net|pussy|penis|uterus|cnc|bdsm|cunt|kink|kinky|discord.gg|join my server|thighs|th1ghs/i)
  event.respond(content: "You're not allowed to use this word in your role name.", ephemeral: false) 
  next
  end
  end

    db = SQLite3::Database.new("settings.db")
    db.results_as_hash = true
    data = db.execute( "select * from boost_servers where server_id = ?", ["#{server_id}"])
    if data.empty?
    event.respond(content: "This server hasn't setup booster perks.", ephemeral: true)
    next
    end  

    
    if event.user.boosting? == false
    event.respond(content: 'Please boost the server to edit your role.', ephemeral: true)
    next
    end





    unless edit_name_input.nil?
    db.results_as_hash = true  
    db.execute( "select * from boosters where client_user_id = ? AND server_boost_origin = ?", ["#{client_id}", "#{server_id}"]) do |row|
    name_role_id = row['role_id']
    server = bot.server(event.server.id)
    role = server.role(name_role_id)    
    role.name = "#{edit_name_input}"
    end
    end

  



  
    unless edit_color_input.nil? 
    db.results_as_hash = true  
    db.execute( "select * from boosters where client_user_id = ? AND server_boost_origin = ?", ["#{client_id}", "#{server_id}"]) do |row|
    color_role_id = row['role_id']
    space_color_edit_check = edit_color_input.strip
    checked_color = remove_hashtag("#{space_color_edit_check}")
    edit_color_passthrough = Discordrb::ColourRGB.new("#{checked_color}")
    server = bot.server(event.server.id)
    role = server.role(color_role_id)    
    role.color = edit_color_passthrough
    end
    end






    unless edit_icon.nil?
    db.results_as_hash = true  
    db.execute( "select * from boosters where client_user_id = ? AND server_boost_origin = ?", ["#{client_id}", "#{server_id}"]) do |row| 
    emoji_number_id = extract_emoji_id(edit_icon)
    icon_role_id = row['role_id']
    edit_emoji_cdn_url = "https://cdn.discordapp.com/emojis/#{emoji_number_id}.png"
    tempfile = Down.download("#{edit_emoji_cdn_url}")
    location = tempfile.path  
    server = bot.server(event.server.id)
    role = server.role(icon_role_id)
    role.icon = File.open("/private#{location}", 'rb')
    tempfile.unlink
    end  
    end
    

    event.respond(content: 'Your role has been successfully edited. <a:LoidClap_Maomao:1276327798104920175>', ephemeral: true)
    rescue Discordrb::Errors::NoPermission => e
    event.respond(content: 'Your role has been successfully edited. <a:LoidClap_Maomao:1276327798104920175>', ephemeral: true)
    db.close  
    end











  group.subcommand(:delete) do |event|

  if event.user.boosting? == false
  event.respond(content: 'Please boost the server to delete your role.', ephemeral: true)
  next
  end  

  db = SQLite3::Database.new("settings.db")
  check_id = event.server.id
  db.results_as_hash = true
  data = db.execute( "select * from boost_servers where server_id = ?", ["#{check_id}"])
  if data.empty?
  event.respond(content: "This server hasn't setup booster perks.", ephemeral: true)
  next
  end  
 
  command_user = event.user
  client_id = command_user.id
  server_id = event.server.id  
  server = bot.server(event.server.id)
  db.results_as_hash = true  
  db.execute( "select * from boosters where client_user_id = ? AND server_boost_origin = ?", ["#{client_id}", "#{server_id}"]) do |row|
  delete_role_id = row['role_id']
  role = server.role(delete_role_id)  
  role.delete
  check = db.execute( "delete from boosters where client_user_id = ?", ["#{client_id}"])
  event.respond(content: 'Your role has been successfully deleted. Please feel free to make a new role at any time. <:YorHeart_Alesetiawan:1276327768979804258>', ephemeral: true)
  end
  end


end











scheduler = Rufus::Scheduler.new
scheduler.every '1d' do
db = SQLite3::Database.new("settings.db")
db.results_as_hash = true
db.execute("SELECT * FROM boosters") do |row|
member_id = row['client_user_id']
server_id = row['server_boost_origin']
role_id = row['role_id']  
deletion = check_boosting_status(bot, server_id, member_id, role_id)
if deletion == true
db.execute("DELETE FROM boosters WHERE role_id = ?", [role_id])
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

end
bot.run
