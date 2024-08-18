require 'discordrb'

require 'sqlite3'

require 'dotenv'

require 'time'

Dotenv.load

bot = Discordrb::Bot.new(token:ENV['BOT_TOKEN'], intents: [:servers, :server_messages])

status = 'online'
activity = 'https://github.com/Droid000/Frost'      
url = nil    
   
bot.ready do bot.update_status(status, activity, url)
end

db = SQLite3::Database.new("server_settings.db")

db.execute_batch <<-SQL
CREATE TABLE IF NOT EXISTS servers (server_id INTEGER NOT NULL PRIMARY KEY, archive_channel_id INTEGER NOT NULL UNIQUE);
SQL

db.close











bot.unknown(type: :CHANNEL_PINS_UPDATE) do |event|
channel_id = event.data["channel_id"].to_i
server_id = event.data["guild_id"].to_i
origin_server = bot.server(server_id)
origin_channel = bot.channel(channel_id)
        
pin_fetch = origin_channel.pins
if pin_fetch.count == 50
second_recent = pin_fetch[1]
username = second_recent.author.username
msg_content = second_recent.content
msg_link = second_recent.link
msg_id = second_recent.id
avatar = second_recent.author.avatar_url(format = "png")
time_raw = second_recent.timestamp.to_s
time_var = Time.parse(time_raw)
time_unix = time_var.to_i
human_time_1 = Time.at(time_unix)
time = human_time_1.strftime('%m/%d/%Y %H:%M')
db = SQLite3::Database.new("server_settings.db")
db.results_as_hash = true
db.execute( "select * from servers where server_id = ?", ["#{server_id}"]) do |row|
archive_channel = row['archive_channel_id']
channel = bot.channel(archive_channel)
if second_recent.attachments.any?
img_in = second_recent.attachments[0]
img_url = img_in.url
channel.send_embed do |embed|
embed.colour = 0x8da99b
embed.description = "#{msg_content}"
embed.image = Discordrb::Webhooks::EmbedImage.new(url: "#{img_url}")             
embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "#{username}", url: "#{msg_link}", icon_url: "#{avatar}")
embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{msg_id} • #{time}")              
embed.add_field(name: "Source", value: "[Jump!](#{msg_link})")
end
        
else  
channel.send_embed do |embed|
embed.colour = 0x8da99b
embed.description = "#{msg_content}"
embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "#{username}", url: "#{msg_link}", icon_url: "#{avatar}")
embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{msg_id} • #{time}")              
embed.add_field(name: "Source", value: "[Jump!](#{msg_link})")
end
end
end
    
second_recent.unpin   
end
end 











bot.register_application_command(:hug, 'Hugs another server member.') do |cmd|
cmd.user('target', 'Who do you want to hug?', required: true)
end
    
    bot.application_command(:hug) do |event|
    hugged = event.options['target']
    hugger = event.user.display_name
    links = ["https://media.tenor.com/P6FsFii7pnoAAAAC/hug-warm-hug.gif", "https://media.tenor.com/AlNzo08uVWwAAAAC/hugs-love.gif", "https://media.tenor.com/bmd6etOp9xMAAAAi/peach-goma-love-peach-and-goma.gif", "https://media.tenor.com/j3EqKeUUhc8AAAAC/big-hug.gif", "https://media.tenor.com/-ubi8dauw7oAAAAd/doghugs-hugs.gif", "https://media.tenor.com/kCZjTqCKiggAAAAC/hug.gif", "https://media.tenor.com/hffoO6g6z4MAAAAC/sad-i-love-you.gif", "https://media.tenor.com/P-8xYwXoGX0AAAAC/anime-hug-hugs.gif", "https://media.tenor.com/Ei1Gg8dZLf8AAAAd/nezuko-chan-hug.gif", "https://media.tenor.com/2ihekCRtiU0AAAAC/chainsaw-man-csm.gif", "https://media.tenor.com/DG72AoRX-nYAAAAC/eren-yeager-armin-arlert.gif", "https://media.tenor.com/wUQH5CF2DJ4AAAAC/horimiya-hug-anime.gif", "https://media.tenor.com/hNSIQIN6h4cAAAAC/my-oni-girl-myonigirl.gif", "https://media.tenor.com/wbntPv9hoXoAAAAC/cuddle-panda.gif", "https://media.tenor.com/jAycgzTbAWwAAAAC/cuddle.gif", "https://media.tenor.com/I7yWOnNCZp0AAAAC/love-hug.gif", "https://media.tenor.com/uXqb4JIrYh4AAAAC/anya-anya-forger.gif", "https://media.tenor.com/sRAoiHobcLMAAAAd/furina-focalors.gif", "https://media.tenor.com/h-QhClhGTKYAAAAC/tbhk-hug.gif", "https://media.tenor.com/1gf_Jz8WYH0AAAAM/sami-en-dina-sami-dina.gif", "https://media.tenor.com/9s3o_CwfCkkAAAAC/hug.gif", "https://media.tenor.com/9daTvX0jz7EAAAAC/hug.gif", "https://media.tenor.com/kz-Os0sECOgAAAAC/frieren-hug.gif", "https://media.tenor.com/BYH8Z_RhioYAAAAd/anya-forger-spy-x-family.gif", "https://media.tenor.com/VXdVaLBMQT4AAAAd/spy-x-family-sxf.gif", "https://media.tenor.com/sQ_isTxT-EEAAAAd/anya-hug.gif", "https://media.tenor.com/U8q_IeWsjXYAAAAd/spy-x-family.gif", "https://media.tenor.com/nN1-MEOONWcAAAAd/forger-forger-family.gif"]
    random_link = links.sample.to_s
    event.respond(content: "<@#{hugged}>", ephemeral: false) do |builder|
    builder.add_embed do |embed|
    embed.colour = 0x33363b
    embed.description = "#{hugger} hugs <@#{hugged}>"
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: random_link)
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "HUGS")
    end
end
end











bot.register_application_command(:poke, 'Pokes another server member.') do |cmd|
cmd.user('target', 'Who do you want to poke?', required: true)
end
    
    bot.application_command(:poke) do |event|
    poked = event.options['target']
    poker = event.user.display_name
    links = ["https://media.tenor.com/iu_Lnd86GxAAAAAC/nekone-utawarerumono.gif", "https://media.tenor.com/3dOqO4vVlr8AAAAC/poke-anime.gif", "https://media.tenor.com/QDNTqOInK5MAAAAC/anime-poke.gif", "https://media.tenor.com/XdfQaUIW4coAAAAC/poke.gif", "https://media.tenor.com/HJa3EjH0iNMAAAAC/poke.gif", "https://media.tenor.com/BEJ8ZjZoySQAAAAC/chicken-chicken-bro.gif", "https://media.tenor.com/B-E9cSUwhw8AAAAC/highschool-dxd-anime.gif", "https://media.tenor.com/ZdIdxRKNC5UAAAAC/poke-the.gif", "https://media.tenor.com/_C06NtBa8pcAAAAC/mochi-poke-poke-cute-cat.gif", "https://media.tenor.com/5sG1YVNFHB0AAAAC/tag2.gif", "https://media.tenor.com/o9X9XXVCm-MAAAAd/bird-cute.gif", "https://media.tenor.com/_UlykyLROmAAAAAC/friend-bird.gif", "https://media.tenor.com/WR_AZJv6CZgAAAAC/pinch-sleepy.gif", "https://media.tenor.com/rPfXDQLJgkcAAAAC/poke-im-not-poking-you.gif", "https://media.tenor.com/k_0aW74y9RwAAAAC/lemongrab-annoying.gif", "https://media.tenor.com/9ikjmqECGMsAAAAd/kanna-poke.gif", "https://media.tenor.com/a18Chj4pnfoAAAAC/chu.gif", "https://media.tenor.com/hlrUN-PqmpsAAAAd/seals-yo-chan.gif", "https://media.tenor.com/15rsqm7SgzEAAAAd/mochi-peach.gif", "https://media.tenor.com/JX8jkW0WP-wAAAAC/cat-poke.gif"]
    random_link = links.sample.to_s
    event.respond(content: "<@#{poked}>", ephemeral: false) do |builder|
    builder.add_embed do |embed|
    embed.colour = 0x33363b
    embed.description = "#{poker} pokes <@#{poked}>"
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: random_link)
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "POKES")
    end
end
end

 






bot.register_application_command(:nom, 'Noms another server member.') do |cmd|
cmd.user('target', 'Who do you want to nom?', required: true)
end
    
    bot.application_command(:nom) do |event|
    i_nom = event.options['target']
    nommies = event.user.display_name
    links = ["https://media.tenor.com/P1EaMHJcM6UAAAAC/nom-love.gif", "https://media.tenor.com/uJnRQZr0wHwAAAAC/aww-cute.gif", "https://media.tenor.com/yEQ4VELSSngAAAAC/milk-mocha-gigit.gif", "https://media.tenor.com/1iv4GLVH8ZkAAAAd/cat-bite.gif", "https://media.tenor.com/tXaWn6FbXjsAAAAC/eating-an-apple-om-nom.gif", "https://media.tenor.com/mKQJKwdnRTcAAAAd/nom-nom-dog.gif", "https://media.tenor.com/qiC0cr4y5-0AAAAC/baby-gobble-nomnomnom.gif", "https://media.tenor.com/4jiyD12NPloAAAAC/bear-biting-face-off.gif", "https://media.tenor.com/gTQqusq0Kt8AAAAd/cat-cat-meme.gif", "https://media.tenor.com/OHJt9nkDwkMAAAAd/dog-cat.gif", "https://media.tenor.com/qfxdtuaqFhAAAAAd/hippopotamus-tender.gif", "https://media.tenor.com/sPTJ8LDiUmcAAAAd/cat-bite.gif", "https://media.tenor.com/DgdTu-hzb2YAAAAC/suck-cheek.gif", "https://media.tenor.com/B9iKDWmmS1wAAAAd/cat-attack-blowntobits-crash-biting.gif", "https://media.tenor.com/QvLlkNlsRDAAAAAC/nom-nom-anime-love.gif", "https://media.tenor.com/SCQI234MDZYAAAAC/iove-bite.gif", "https://media.tenor.com/zxXXGjV98bcAAAAC/kawaii-anime-girl-bite.gif"]
    random_link = links.sample.to_s
    event.respond(content: "<@#{i_nom}>", ephemeral: false) do |builder|
    builder.add_embed do |embed|
    embed.colour = 0x33363b
    embed.description = "#{nommies} noms <@#{i_nom}>"
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: random_link)
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "NOMS")
    end
end
end 









bot.register_application_command(:angered, 'Shows your anger another server member.') do |cmd|
cmd.user('target', 'Who do you want to show your wrath to?', required: true)
end
    
    bot.application_command(:angered) do |event|
    victim = event.options['target']
    angered = event.user.display_name
    links = ["https://media.tenor.com/qQYDljPy96oAAAAC/anime-angry.gif", "https://media.tenor.com/0dc7tgGjf6gAAAAC/peach-goma-peach.gif", "https://media.tenor.com/I8rERNy4qfEAAAAC/simpson-homer-simpson.gif", "https://media.tenor.com/3HE1TE3dn6EAAAAC/cute-adorable.gif", "https://media.tenor.com/mtkt0dH035QAAAAC/pepo21.gif", "https://media.tenor.com/tx3x8ANgbBwAAAAC/the-dreaming-boy-is-a-realist-yumemiru-danshi.gif", "https://media.tenor.com/sy9rSYqF3v8AAAAC/colere.gif", "https://media.tenor.com/RLk2ghNYsesAAAAC/cute-cat.gif", "https://media.tenor.com/UPAm3NvEx4wAAAAC/anime-angry.gif", "https://media.tenor.com/pbqNBWOx6xUAAAAC/annoyed-anime-girl-annoyed.gif", "https://media.tenor.com/qQjvk3k1MmYAAAAC/yor-yor-anime.gif", "https://media.tenor.com/Scu6ExRW824AAAAC/inside-out.gif", "https://media.tenor.com/rxKwCmIpyp8AAAAC/tantrum.gif", "https://media.tenor.com/z2iFD-hLYnAAAAAC/anime-girl-anime.gif", "https://media.tenor.com/O7_ZgFSBGZIAAAAd/angry-cat-sour-cat.gif", "https://media.tenor.com/aZ1PR9DpnOYAAAAC/annoyed-disappointed.gif", "https://media.tenor.com/G9qmH_P1nbsAAAAd/angry-angry-cat.gif", "https://media.tenor.com/bf_mVk_EEYwAAAAC/bbbb.gif", "https://media.tenor.com/yo2Vzfau4G0AAAAd/cat-stare-angry-cat.gif", "https://media.tenor.com/fhs_bExUoR0AAAAd/angry-anime.gif"]
    random_link = links.sample.to_s
    event.respond(content: "<@#{victim}>", ephemeral: false) do |builder|
    builder.add_embed do |embed|
    embed.colour = 0x33363b
    embed.description = "Watch out <@#{victim}>! Someone seems to be angry today."
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: random_link)
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "ANGRY")
    end
end
end  











bot.register_application_command(:sleep, 'Tell another server member to go and sleep.') do |cmd|
cmd.user('target', 'Who needs to sleep?', required: true)
end
    
    bot.application_command(:sleep) do |event|
    go_sleep = event.options['target']
    resp = event.user.display_name
    links = ["https://media.tenor.com/8MuYO-3_LUEAAAAC/milk-and-mocha-bear-couple.gif", "https://media.tenor.com/JytsJ0Mlb8wAAAAC/sleep-time.gif", "https://media.tenor.com/753VtyeLsH4AAAAC/stitch-sleep-sleep.gif", "https://media.tenor.com/l0KyHhRbH1AAAAAC/tired-sleep.gif", "https://media.tenor.com/ifI1z7JYgTIAAAAC/phoneline-sleep.gif", "https://media.tenor.com/S5N8d-OpyNEAAAAC/extasyxx.gif", "https://media.tenor.com/TG_JLONAbSEAAAAC/quby-quby-sticker.gif", "https://media.tenor.com/_Qp9Kn3s1P4AAAAd/i-sleep-meme-sleep.gif", "https://media.tenor.com/TE_jqQ1HW50AAAAd/dog-sleep-dog-sleeping-w-goofy-sleeping-sound.gif", "https://media.tenor.com/GhaZsr7etQoAAAAC/a-labrador-drooling-labrador.gif", "https://media.tenor.com/HItBOocy6ikAAAAC/umaru-sleeping.gif", "https://media.tenor.com/lFCX6zJnNNMAAAAC/frieren-anime.gif", "https://media.tenor.com/NUc4M9ix-kUAAAAC/kotori-minami-sleeping.gif", "https://media.tenor.com/7ze6WIOcsY0AAAAC/sleeping-anime.gif", "https://media.tenor.com/BV0xBnKK6VIAAAAd/anime-sofa.gif","https://media.tenor.com/w8bVOlSAZkUAAAAC/spy-x-family-anya-spy-x-family.gif", "https://media.tenor.com/2nuT6e9IvZ4AAAAi/milk-and-mocha.gif"]
    random_link = links.sample.to_s
    event.respond(content: "<@#{go_sleep}>", ephemeral: false) do |builder|
    builder.add_embed do |embed|
    embed.colour = 0x33363b
    embed.description = "#{resp} says <@#{go_sleep}> should go to sleep!"
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: random_link)
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "SLEEPY")
    end
end
end











bot.register_application_command(:archive, 'Archives pins in a specified channel.') do |cmd|
cmd.channel('channel', 'Which channel needs to have its pins archived?', required: true)    
end

    bot.application_command(:archive) do |event|
    event.defer    
    db = SQLite3::Database.new("server_settings.db")    
    client_server_id = event.server.id   
    user = event.user
    perm_check = user.permission?(:manage_messages, channel = nil)
    if perm_check == false
    event.edit_response(content: "You need to have the ``manage messages`` permission to use this command.")      
    next
    end    
    
    audit_channel = event.options['channel']
    resolve_audit = bot.channel(audit_channel)
    current_pins = resolve_audit.pins
    if current_pins.count == 50
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
    time = human_time_1.strftime('%m/%d/%Y %H:%M')
    db.results_as_hash = true
    db.execute( "select * from servers where server_id = ?", ["#{client_server_id}"]) do |row|
    archive_channel = row['archive_channel_id']
    channel = bot.channel(archive_channel)
    
    if second_recent.attachments.any?
    img_in = second_recent.attachments[0]
    img_url = img_in.url
    channel.send_embed do |embed|
    embed.colour = 0x8da99b
    embed.description = "#{msg_content}"
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: "#{img_url}")             
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "#{username}", url: "#{msg_link}", icon_url: "#{avatar}")
    embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{msg_id} • #{time}")              
    embed.add_field(name: "Source", value: "[Jump!](#{msg_link})")
    end
    
    else  
    channel.send_embed do |embed|
    embed.colour = 0x8da99b
    embed.description = "#{msg_content}"
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "#{username}", url: "#{msg_link}", icon_url: "#{avatar}")
    embed.footer = Discordrb::Webhooks::EmbedFooter.new(text: "#{msg_id} • #{time}")              
    embed.add_field(name: "Source", value: "[Jump!](#{msg_link})")
    end
    end
    end
    
    
    second_recent.unpin
    event.edit_response(content: "Succesfully archived one pin by **#{username}**!")  
end
end  
 









bot.register_application_command(:setup, 'Setup the pin-archiver functionality.') do |cmd|
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










bot.register_application_command(:shutdown, 'Safely disconnects the bot from the Gateway.') do |cmd|
end  
    
    bot.application_command(:shutdown) do |event|
    if event.user.id == 673658900435697665
    event.respond(content: "The bot has powered off.", ephemeral: true)
    bot.stop 
    else
    event.respond(content: "You don't have the nessecary permissions to do this.", ephemeral: true)
end    
end












bot.register_application_command(:help, 'Shows information about how to use the bot.') do |cmd|
end
        
    bot.application_command(:help) do |event|
    event.respond(ephemeral: true) do |builder|
    builder.add_embed do |embed|
    embed.title = "**Help**"
    embed.colour = 0xd4f0ff
    embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "https://cdn.discordapp.com/avatars/1268769768920580156/1551613008086970c244a81d043d354e?size=1024")
    embed.footer = Discordrb::Webhooks::EmbedFooter.new()
    embed.add_field(name: "``/help``", value: "Opens the help menu.")
    embed.add_field(name: "``/about``", value: "Shows some information about the bot.")
    embed.add_field(name: "``/shutdown``", value: "Allows the bot owner to shutdown the bot.")
    embed.add_field(name: "``/hug``", value: "Sends a random GIF to hug a server member.")
    embed.add_field(name: "``/poke``", value: "Sends a random GIF to poke a server member.")
    embed.add_field(name: "``/nom``", value: "Sends a random GIF to nom a server member.")
    embed.add_field(name: "``/angered``", value: "Sends a random GIF to show your anger towards a server member.")
    embed.add_field(name: "``/sleep``", value: "Sends a random GIF to tell a server member to go to sleep.")
    embed.add_field(name: "``/setup``", value: "Sets up the pin-archiver functionality. Run this command again if you want to change your settings.")
    embed.add_field(name: "``/archive``", value: "Archives the second most recent pinned message in the specified channel.")
    end 
end
end   
    
    

bot.register_application_command(:about, 'Shows some information about the bot.') do |cmd|
end

bot.application_command(:about) do |event|
event.respond(content: 'Made by *droid00000* using the [discordrb library!](<https://github.com/shardlab/discordrb>) <a:RubyPandaHeart:1269075581031546880>', ephemeral: true)
end





bot.run
