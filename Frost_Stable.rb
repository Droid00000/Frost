require 'discordrb'

bot = Discordrb::Bot.new(token:'TOKEN_HERE', intents: [:server_messages])










bot.register_application_command(:hug, 'Hugs another server member.') do |cmd|
cmd.user('target', 'Who do you want to hug?', required: true)
end
    
    bot.application_command(:hug) do |event|
    hugged = event.options['target']
    hugger = event.user.display_name
    links = ["https://media.tenor.com/P6FsFii7pnoAAAAC/hug-warm-hug.gif", "https://media.tenor.com/AlNzo08uVWwAAAAC/hugs-love.gif", "https://media.tenor.com/bmd6etOp9xMAAAAi/peach-goma-love-peach-and-goma.gif", "https://media.tenor.com/j3EqKeUUhc8AAAAC/big-hug.gif", "https://media.tenor.com/-ubi8dauw7oAAAAd/doghugs-hugs.gif", "https://media.tenor.com/kCZjTqCKiggAAAAC/hug.gif", "https://media.tenor.com/hffoO6g6z4MAAAAC/sad-i-love-you.gif", "https://media.tenor.com/P-8xYwXoGX0AAAAC/anime-hug-hugs.gif", "https://media.tenor.com/Ei1Gg8dZLf8AAAAd/nezuko-chan-hug.gif", "https://media.tenor.com/XrbHCaTCRw0AAAAd/himeno-chainsaw-man.gif", "https://media.tenor.com/2ihekCRtiU0AAAAC/chainsaw-man-csm.gif", "https://media.tenor.com/DG72AoRX-nYAAAAC/eren-yeager-armin-arlert.gif", "https://media.tenor.com/wUQH5CF2DJ4AAAAC/horimiya-hug-anime.gif", "https://media.tenor.com/hNSIQIN6h4cAAAAC/my-oni-girl-myonigirl.gif", "https://media.tenor.com/wbntPv9hoXoAAAAC/cuddle-panda.gif", "https://media.tenor.com/jAycgzTbAWwAAAAC/cuddle.gif", "https://media.tenor.com/I7yWOnNCZp0AAAAC/love-hug.gif", "https://media.tenor.com/uXqb4JIrYh4AAAAC/anya-anya-forger.gif", "https://media.tenor.com/sRAoiHobcLMAAAAd/furina-focalors.gif", "https://media.tenor.com/h-QhClhGTKYAAAAC/tbhk-hug.gif", "https://media.tenor.com/1gf_Jz8WYH0AAAAM/sami-en-dina-sami-dina.gif", "https://media.tenor.com/9s3o_CwfCkkAAAAC/hug.gif", "https://media.tenor.com/9daTvX0jz7EAAAAC/hug.gif", "https://media.tenor.com/kz-Os0sECOgAAAAC/frieren-hug.gif", "https://media.tenor.com/BYH8Z_RhioYAAAAd/anya-forger-spy-x-family.gif", "https://media.tenor.com/VXdVaLBMQT4AAAAd/spy-x-family-sxf.gif", "https://media.tenor.com/sQ_isTxT-EEAAAAd/anya-hug.gif", "https://media.tenor.com/U8q_IeWsjXYAAAAd/spy-x-family.gif", "https://media.tenor.com/nN1-MEOONWcAAAAd/forger-forger-family.gif"]
    random_link = links.sample.to_s
    event.respond(content: "<@#{hugged}>", ephemeral: false)
    event.channel.send_embed do |embed|
    embed.colour = 0x33363b
    embed.description = "#{hugger} hugs <@#{hugged}>"
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: random_link)
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "HUGS")
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
    event.respond(content: "<@#{poked}>", ephemeral: false)
    event.channel.send_embed do |embed|
    embed.colour = 0x33363b
    embed.description = "#{poker} pokes <@#{poked}>"
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: random_link)
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "POKES")
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
    event.respond(content: "<@#{i_nom}>", ephemeral: false)
    event.channel.send_embed do |embed|
    embed.colour = 0x33363b
    embed.description = "#{nommies} noms <@#{i_nom}>"
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: random_link)
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "NOMS")
    end
    end 









bot.register_application_command(:angered, 'Shows your anger another server member.') do |cmd|
cmd.user('target', 'Who do you show your wrath to?', required: true)
end
    
    bot.application_command(:angered) do |event|
    victim = event.options['target']
    angered = event.user.display_name
    links = ["https://media.tenor.com/qQYDljPy96oAAAAC/anime-angry.gif", "https://media.tenor.com/0dc7tgGjf6gAAAAC/peach-goma-peach.gif", "https://media.tenor.com/I8rERNy4qfEAAAAC/simpson-homer-simpson.gif", "https://media.tenor.com/3HE1TE3dn6EAAAAC/cute-adorable.gif", "https://media.tenor.com/mtkt0dH035QAAAAC/pepo21.gif", "https://media.tenor.com/tx3x8ANgbBwAAAAC/the-dreaming-boy-is-a-realist-yumemiru-danshi.gif", "https://media.tenor.com/sy9rSYqF3v8AAAAC/colere.gif", "https://media.tenor.com/RLk2ghNYsesAAAAC/cute-cat.gif", "https://media.tenor.com/UPAm3NvEx4wAAAAC/anime-angry.gif", "https://media.tenor.com/pbqNBWOx6xUAAAAC/annoyed-anime-girl-annoyed.gif", "https://media.tenor.com/qQjvk3k1MmYAAAAC/yor-yor-anime.gif", "https://media.tenor.com/Scu6ExRW824AAAAC/inside-out.gif", "https://media.tenor.com/rxKwCmIpyp8AAAAC/tantrum.gif", "https://media.tenor.com/z2iFD-hLYnAAAAAC/anime-girl-anime.gif", "https://media.tenor.com/O7_ZgFSBGZIAAAAd/angry-cat-sour-cat.gif", "https://media.tenor.com/aZ1PR9DpnOYAAAAC/annoyed-disappointed.gif", "https://media.tenor.com/G9qmH_P1nbsAAAAd/angry-angry-cat.gif", "https://media.tenor.com/bf_mVk_EEYwAAAAC/bbbb.gif", "https://media.tenor.com/yo2Vzfau4G0AAAAd/cat-stare-angry-cat.gif", "https://media.tenor.com/fhs_bExUoR0AAAAd/angry-anime.gif"]
    random_link = links.sample.to_s
    event.respond(content: "<@#{victim}>", ephemeral: false)
    event.channel.send_embed do |embed|
    embed.colour = 0x33363b
    embed.description = "Watch out <@#{victim}>! Someone seems to be angry today."
    embed.image = Discordrb::Webhooks::EmbedImage.new(url: random_link)
    embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "ANGRY")
    end
    end  











bot.register_application_command(:sleep, 'Tells a server member to go to sleep.') do |cmd|
cmd.user('target', 'Who needs to go to sleep?', required: true)
end
                        
        bot.application_command(:sleep) do |event|
        bedtime = event.options['target']
        parent = event.user.display_name
        links = []
        random_link = links.sample.to_s
        event.respond(content: "<@#{bedtime}>", ephemeral: false)
        event.respond.channel.send_embed do |embed|
        embed.colour = 0x33363b
        embed.description = "#{parent} tells <@#{bedtime}> to go to sleep!"
        embed.image = Discordrb::Webhooks::EmbedImage.new(url: random_link)
        embed.author = Discordrb::Webhooks::EmbedAuthor.new(name: "SLEEPY")
        end
        end  





 































    
bot.register_application_command(:shutdown, 'Safely disconnects the bot.') do |cmd|
end  
    
    bot.application_command(:shutdown) do |event|
    break unless event.user.id == 673658900435697665
    event.respond(content: "The bot has powered off.", ephemeral: true)
    bot.stop 
    end












bot.register_application_command(:help, 'Shows information about how to use the bot.') do |cmd|
end
        
    bot.application_command(:help) do |event|
    event.respond(content: "_ _", ephemeral: false)
    event.channel.send_embed do |embed|
    embed.title = "**Help**"
    embed.colour = 0xd4f0ff
    embed.thumbnail = Discordrb::Webhooks::EmbedThumbnail.new(url: "https://cdn.discordapp.com/avatars/1268769768920580156/1551613008086970c244a81d043d354e?size=1024")
    embed.footer = Discordrb::Webhooks::EmbedFooter.new()
    embed.add_field(name: "``/help``", value: "Opens the ``/help`` menu.")
    embed.add_field(name: "``/about``", value: "Shows some information about the bot.")
    embed.add_field(name: "``/shutdown``", value: "Allows the bot owner to shutdown the bot.")
    embed.add_field(name: "``/hug``", value: "Sends a random GIF to hug a server member.")
    embed.add_field(name: "``/poke``", value: "Sends a random GIF to poke a server member.")
    embed.add_field(name: "``/nom``", value: "Sends a random GIF to nom a server member.")
    embed.add_field(name: "``/angered``", value: "Sends a random GIF to show your anger towards a server member.")
    embed.add_field(name: "``/sleep``", value: "Sends a random GIF to tell a server member to go to sleep.") 
    end
    end   
    
    

bot.register_application_command(:about, 'Shows some information about the bot.') do |cmd|
end

    bot.application_command(:about) do |event|
    event.respond(content: 'Made by *droid00000* using the [discordrb library!](<https://github.com/shardlab/discordrb>) <a:RubyPandaHeart:1269075581031546880>', ephemeral: true)
    end



status = 'online'
activity = 'https://github.com/Droid000/Frost'      
url = nil    
   
bot.ready do bot.update_status(status, activity, url)
end

bot.run