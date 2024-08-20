require 'discordrb'

require 'sqlite3'

require 'dotenv'

Dotenv.load

bot = Discordrb::Bot.new(token:ENV['BOT_TOKEN'], intents: [:server_messages])

db = SQLite3::Database.new("server_leaderboard.db")
db.execute_batch <<-SQL
CREATE TABLE IF NOT EXISTS score (server_id INTEGER NOT NULL PRIMARY KEY, user_id INTEGER NOT NULL UNIQUE, snowball_amount INTEGER);
SQL
db.close


bot.register_application_command(:throw, 'Snowball fights', server_id: ENV['SLASH_COMMAND_SERVER_ID']) do |cmd|
cmd.subcommand('snowball', 'Throw a snowball at someone!') do |sub|
sub.user('member', 'Who do you want to hit with a snowball?', required: true)    
end
end

bot.register_application_command(:collect, 'Snowball fights', server_id: ENV['SLASH_COMMAND_SERVER_ID']) do |cmd|
cmd.subcommand('snowball', 'Collect a snowball!') do |sub|
end
end 

bot.register_application_command(:steal, 'Snowball fights', server_id: ENV['SLASH_COMMAND_SERVER_ID']) do |cmd|
cmd.subcommand('snowball', 'Steal a snowball from someone!') do |sub|
sub.user('member', 'Who do you want to steal snowballs from?', required: true)
sub.integer('amount', 'How many snowballs do you want to steal?', choices: { two: '2', three: '3', four: '4', five: '5' }, required: true)          
end     
end

bot.application_command(:collect).subcommand(:snowball) do |event|

    collecter = event.user.display_name
    links = ['https://media.tenor.com/oXY0XhDrZ_kAAAAi/menhera-chan.gif', 'https://media.tenor.com/odNpnufgwkYAAAAC/anime-cute.gif', 'https://media.tenor.com/W7og11vOuFoAAAAC/elodrai-snowball.gif', 'https://media.tenor.com/8UrTfVBMVmwAAAAi/rock-up.gif']
    random_link = links.sample.to_s    
    event.respond(ephemeral: true) do |builder|
    builder.add_embed do |embed|
    embed.colour = 0x33363b
    embed.description = "#{collecter} collected one snowball!"
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: random_link)
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "GATHER")
    end 
end
end


bot.application_command(:throw).subcommand(:snowball) do |event|

    attacker = event.user.display_name
    attacked = event.options['member']
    links = ['https://media.tenor.com/FGCpXFkX3dIAAAAC/anime.gif', 'https://media.tenor.com/PPWAjdhbGnwAAAAd/goblin-kids-goblin-baby.gif', 'https://media.tenor.com/yAvKjzxBGeoAAAAi/snowball-fight.gif', 'https://media.tenor.com/ZZeR0E20gfAAAAAC/ash-serena-ash.gif', 'https://media.tenor.com/pvMYzXPpVLIAAAAd/acchi-kocchi-anime.gif', 'https://media.tenor.com/kyxVTl1Ee2YAAAAd/senko-san-snowball.gif', 'https://media.tenor.com/9pbG2ld4H8UAAAAC/snow-snowing.gif', 'https://media.tenor.com/PfJisM8oiCwAAAAd/azumanga-daioh-azumanga.gif', 'https://media.tenor.com/sD2AcewwSMIAAAAC/snow-ball-take-down.gif', 'https://media.tenor.com/oQw7uToR0mgAAAAC/amaura-ice-dinosaur.gif', 'https://media.tenor.com/EAQwlGXm0_AAAAAC/takane-enomoto-enomoto-takane.gif', 'https://media.tenor.com/1m74jUqgxcUAAAAC/inazuma-eleven-ina11.gif', 'https://media.tenor.com/3WmCUSj3DlQAAAAd/laura-tropical-rouge-precure.gif', 'https://media.tenor.com/L4LB732P7JcAAAAd/the-prince-and-the-pauper-snowball-fight.gif', 'https://media.tenor.com/WU7P9UBpzMUAAAAd/kurumi-erika-laura.gif']
    random_link = links.sample.to_s
    random_number = rand(1..10)
    if random_number >= 5      
    event.respond(content: "<@#{attacked}>", ephemeral: false) do |builder|
    builder.add_embed do |embed|
    embed.colour = 0x33363b
    embed.description = "#{attacker} throws a snowball at <@#{attacked}>"
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: random_link)
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "ATTACK")
    next 
    end
    end
    end

    if random_number < 5
    event.respond(content: "You missed!", ephemeral: false)
    end
    end    

bot.application_command(:steal).subcommand(:snowball) do |event|

    stealer = event.user.display_name
    stolen = event.options['member']
    amount = event.options['amount']
    links = []
    random_link = links.sample.to_s    
    event.respond(content: "<@#{stolen}>", ephemeral: false) do |builder|
    builder.add_embed do |embed|
    embed.colour = 0x33363b
    embed.description = "#{stealer} stole #{amount} snowballs from <@#{stolen}>"
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: random_link)
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "STEAL")
    end        
end
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


bot.run