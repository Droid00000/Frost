# frozen_string_literal: true

# A response message to an interaction.
RESPONSE = {
  1 => "Your role has been created! You can always edit your role using the </booster role edit:1312281524321648651> command.",
  2 => "Your role has been successfully edited!",
  3 => "Your role has been successfully deleted! Feel free to make a new role at any time.",
  4 => "You've already claimed your custom role on this server.",
  5 => "This functionality has not been enabled on this server.",
  6 => "You have been banned from using this feature.",
  7 => "Invalid name parameter.",
  8 => "You aren't boosting this server.",
  9 => "We couldn't find your role. Please use the </booster role claim:1312281524321648651> command to claim your role.",
  10 => "Made by *droid00000* using the [discordrb library!](<https://github.com/shardlab/discordrb>)",
  11 => "Invalid status parameter.",
  12 => "You must be a contributor to use this command.",
  13 => "Successfully updated the status! Thank you for contributing to my bot!",
  14 => "You're out of snowballs! You can collect more using the </collect snowball:1312281435675033711> command!",
  15 => "You missed!",
  16 => "This user doesn't have any snowballs.",
  17 => "That role cannot be updated.",
  18 => "``401: Unauthorized``",
  19 => "The bot has powered off.",
  20 => "Succesfully archived one pinned message!",
  21 => "This user doesn't have enough snowballs.",
  22 => "Successfully set the archive channel to: <#%s>",
  23 => "You've already setup event perks for this role.",
  24 => "Successfully setup event perks for this role: <@&%s>",
  25 => "This user is already a booster in this server.",
  26 => "Successfully added the following user to the database: <@%s>",
  27 => "This user isn't boosting your server, or hasn't claimed their role.",
  28 => "Successfully removed the following user from the database: <@%s>",
  29 => "This user has already been banned from using the booster perks functionality.",
  30 => "Successfully banned the following user from using the booster perks functionality: <@%s>",
  31 => "This user isn't banned from using the booster perks functionality.",
  32 => "Successfully un-banned the following user from using the booster perks functionality: <@%s>",
  33 => "Successfully set your hoist-role to the following role: <@&%s>",
  34 => "Booster perks are already disabled in this server.",
  35 => "Successfully disabled booster perks in this server.",
  36 => "This server hasn't enabled the pin archiver.",
  37 => "Successfully disabled the pin archiver in this server.",
  38 => "This server hasn't enabled event perks.",
  39 => "Successfully disabled event perks in this server.",
  40 => "Locked down **%s** %s.",
  41 => "Successfully unlocked the server.",
  42 => "This message doesn't have any emojis.",
  43 => "Added this emoji to the server:",
  44 => "Added **%s** emoji(s) to the server.",
  45 => "This server is out of emoji slots.",
  46 => "This server has reached the maximum amount of roles.",
  47 => "The bot needs to have the ``manage roles`` permission to do this.",
  48 => "The bot needs to have the ``manage expressions`` permission to do this.",
  49 => "The bot needs to have the ``manage channels`` permission to do this.",
  50 => "Successfully restarting the bot.",
  51 => "The bot needs to have the ``ban members`` permission to do this.",
  52 => "The bot needs to have the ``manage server`` permission to do this.",
  53 => "Successfully banned **%s** user(s).",
  54 => "You do not have permission to ban any user you've specified.",
  55 => "There are many reasons as to why the chapter could be delayed. Please be paitent and wait.",
  56 => "**Next Chapter:** <t:%s:D>",
  57 => "Successfully blocked <@%s> from viewing this channel.",
  58 => "You cannot perform this action on this member.",
  59 => "The bot needs to have the ``timeout members`` permission to do this.",
  60 => "Invalid duration parameter.",
  61 => "A mute can only last up to 28 days.",
  62 => "You may not mute this user.",
  63 => "Successfully timed out <@%s>.",
  64 => "There aren't any emojis stats available for this server!",
  65 => "Changed this member's nickname: <@%s>",
  66 => "The bot needs to have the ``manage nicknames`` permission to do this.",
  67 => "The bot needs to have the ``manage messages`` permission to do this.",
  68 => "Successfully deleted **%s** message(s).",
  69 => "The bot doesn't have permissions to do this!",
  70 => "Stole **%s** snowballs!",
  71 => "You're not connected to a voice channel.",
  72 => "Couldn't resolve this track.",
  73 => "Something went wrong when connecting to the voice channel.",
  74 => "The bot is already paused.",
  75 => "The bot isn't in a voice channel.",
  76 => "Successfully paused playback.",
  77 => "This bot isn't paused.",
  78 => "Successfully resumed playback.",
  79 => "There aren't any tracks in the queue!",
  80 => "Successfully changed the volume.",
  81 => "This player is currently paused.",
  82 => "An audio player doesn't exist for this server.",
  83 => "There's only a single track left in the queue!"
}.freeze

# Values for embed responses.
EMBED = {
  23 => "**%s** says **%s** should go to bed!",
  24 => "**%s** punches **%s**!",
  25 => "**%s** pokes **%s**!",
  26 => "**%s** hugs **%s**!",
  27 => "**%s** noms **%s**!",
  28 => "**%s** bonks **%s**!",
  29 => "Watch out **%s**! Someone seems to be angry today!",
  30 => "**%s** collected one snowball!",
  31 => "Successfully stole **%s** snowball(s)!",
  32 => "**%s** missed!",
  33 => "**%s** threw a snowball at <@%s>!",
  34 => "Select the Emojis you want to add!",
  35 => "**Enabled:** No",
  36 => "**ANGER**",
  37 => "**BONKS**",
  38 => "**HUGS**",
  39 => "**NOMS**",
  40 => "**POKES**",
  41 => "**PUNCH**",
  42 => "**SLEEP**",
  43 => "**GATHER**",
  44 => "**HIT**",
  45 => "**MISS**",
  46 => "**COMMANDS**",
  47 => "**Booster Moderation**",
  48 => "**Server Boosters**",
  49 => "**Server Settings**",
  50 => "Emoji Statistics for %s",
  51 => "These are the current emoji stats for your server. Non-animated and animated emojis are mixed. Thank you for your support.",
  52 => "Top Emojis ⬆️",
  53 => "Boring Emojis ⬇️",
  54 => "**Archive Channel:** <#%s>",
  55 => "**Hoist Role:** <@&%s>",
  56 => "**Roles:** %s",
  57 => "Moderation",
  58 => "Boosters",
  59 => "Pins",
  60 => "Emojis",
  61 => "Moderation related commands.",
  62 => "Commands for server boosters.",
  63 => "Commands for the pin archiver.",
  64 => "Commands for emoji operations.",
  65 => "Select a category...",
  66 => "Snowballs",
  67 => "Commands for snowball fights.",
  68 => "**Main Menu**",
  69 => "Hi! Welcome to the help page. Use the dropdown menu below to view a category.",
  70 => "About Me",
  71 => "I was made by *droid00000*! My code is open source and can be viewed [here!](<https://github.com/Droid00000/Frost>)",
  72 => "**Server Moderation**",
  73 => "**Pin Archiver**",
  74 => "The Pin archiver automatically archives pins when the pinned message limit is reached. The second most recent pinned message is the one that's archived.",
  75 => "Sets up the pin archiver. When the archiver has already been setup the archive channel will be updated.",
  76 => "Disables the pin archiver preventing pins from being archived.",
  77 => "Manually archives the pins in the channel it's invoked in.",
  78 => "`/pin archiver setup`",
  79 => "`/pin archiver disable`",
  80 => "`/archive`",
  81 => "MOD",
  82 => "PINS",
  83 => "EMOJI",
  84 => "BOOST",
  85 => "SNOW",
  86 => "**Emoji Operations**",
  87 => "Emoji operations allow you to perform actions on emojis. See the commands below for more emojis.",
  88 => "`/add emoji(s)`",
  89 => "Shows a select menu that allows you to choose which emojis to add from a message.",
  90 => "Adds every emoji in a message to your server.",
  91 => "`/add emojis`",
  92 => "`/emoji stats`",
  93 => "Shows emoji stats for your server. Stats are logged by default, so no special setup is required.",
  94 => "**Snowball Fights**",
  95 => "Snowball fights, well... let you have snowball fights with other members!",
  96 => "`/collect snowball`",
  97 => "`/throw snowball`",
  98 => "`/steal snowball`",
  99 => "Adds one snowball to your current balance.",
  100 => "Throws a snowball at another member. Costs one snowball.",
  101 => "Steals a snowball from another member. Requires target to have the amount you're stealing. Currently contributor only.",
  102 => "This bot includes moderation commands. The permissions needed to use a command are what you would expect. E.g. the mute command requires timeout members permission.",
  103 => "`/bulk ban`",
  104 => "`/mute`",
  105 => "`/freeze`",
  106 => "`/unfreeze`",
  107 => "`/change nickname`",
  108 => "`/block`",
  109 => "Bans up to 500 members in one go. This command may take a while to proccess and appear to be in a \"loading\" state.",
  110 => "Sets a timeout up to 28 days for a member. Does not work on administrator's or the server owner.",
  111 => "Prevents members from talking in a server for a specified amount of time or indefinetely.",
  112 => "Removes the timeout caused by the freeze command.",
  113 => "Changes a members nickname to the specified option.",
  114 => "Blocks the member from viewing the channel the command is used in. If cascade is set to true applies to every channel in the server.",
  115 => "`/purge messages`",
  116 => "Deletes up to 600 messages in the channel the command is used in. Cannot delete messages older than 2 weeks.",
  117 => "``/booster role delete``",
  118 => "``/booster role claim``",
  119 => "``/booster role edit``",
  120 => "Booster perks allow you to reward the boosters of your server with configurable perks such as custom roles.",
  121 => "This command permanently deletes your custom role in this server.",
  122 => "This command changes your custom role in this server. All parameters are optional.",
  123 => "This command creates your custom role in this server.",
  124 => "Admin Commands",
  125 => "admin",
  126 => "index",
  127 => "``/booster admin disable``",
  128 => "``/booster admin delete``",
  129 => "``/booster admin setup``",
  130 => "``/booster admin unban``",
  131 => "``/booster admin ban``",
  132 => "``/booster admin add``",
  134 => "Booster perks come with a set of commands in order to protect your community from bad actors.",
  135 => "Disables booster perks on this server.",
  136 => "Manually removes a booster from the bot's database.",
  137 => "Sets up booster perks on this server. The hoist role is the role all custom roles will be placed above.",
  138 => "Removes a ban placed upon a member in this server.",
  139 => "Prevents a member from accessing booster perks on this server. Removes their custom role if they have one.",
  140 => "Manually adds a booster to the bot's database.",
  141 => "**Duration:** `%s`",
  142 => "Requested by %s",
  144 => "Pause",
  145 => "Resume",
  146 => "Next",
  147 => "Now Playing",
  148 => "Next Playing",
  149 => "Music Queue for %s",
  150 => "This is the current music queue for this server. The next 15 songs, and last 15 songs are shown.",
  151 => "First ⬆️",
  152 => "Last ⬇️"
}.freeze

# The audit log reason shown whenever the bot does something.
REASON = {
  1 => "Server booster claimed role.",
  2 => "Server booster updated role.",
  3 => "Server booster deleted role.",
  4 => "Auto-update chapter release date.",
  5 => "Event winner updated role.",
  6 => "Server booster stopped boosting.",
  7 => "Auto-archive pinned messages.",
  8 => "Server member added sticker.",
  9 => "Server member froze the server.",
  10 => "Server member unfroze the server.",
  11 => "Automatic scheduled unfreeze.",
  12 => "Server member was blocked."
}.freeze

# Emojis that the bot can use.
EMOJI = {
  1 => "<a:RubyPandaHeart:1269075581031546880>",
  2 => "<a:LoidClap_Maomao:1276327798104920175>",
  3 => "<a:YorClap_Maomao:1287269908157038592>",
  4 => "<:AnyaPeek_Enzo:1276327731113627679>",
  5 => "<a:LoidDance_Maomao:1295667431674482741>",
  6 => "<a:LoidBell_Maomao:1295667609961758731>",
  7 => "<:AnyaPlead_Maomao:1310804270240628816>"
}.freeze

# UI components including color values.
UI = {
  1 => "https://cdn.discordapp.com/avatars/1268769768920580156/1551613008086970c244a81d043d354e?size=1024",
  2 => 0x89abd2,
  3 => 0x33363b,
  4 => 0x8da99b,
  5 => 0xd4f0ff,
  6 => 0x4d94e8,
  7 => 0x6bb7ed,
  8 => 0x849fe8
}.freeze

# The YAML configuration file used by the bot.
CONFIG = YAML.load_file("#{$LOAD_PATH.first}/config.yml")

# The Postgres database instance used by the bot.
POSTGRES = Sequel.connect(CONFIG["Postgres"]["URL"], extensions: :connection_validator)

POSTGRES.pool.connection_validation_timeout = -1

# The lavalink client used by the bot to play music.
CALLIOPE = Calliope::Client.new(CONFIG["Lavalink"]["URL"], CONFIG["Lavalink"]["TOKEN"], CONFIG["Lavalink"]["ID"])

# A series of regular expressions utilized by the bot.
REGEX = {
  1 => /:(\d+)>$/,
  2 => /\A#?[0-9A-Fa-f]{3}([0-9A-Fa-f]{3})?\z/,
  3 => /<(a?):([a-zA-Z0-9_]{1,32}):([0-9]{15,20})>/,
  4 => /(?<=<@|\s|^)\d+(?=>|\s|$)/,
  5 => /fag|f@g|bitch|b1tch|faggot|whore|wh0re|tranny|tr@nny|nigger|
          nigga|faggot|nibba|n1g|n1gger|nigaboo|n1gga|n i g g e r|n i g g a|
          @everyone|r34|porn|hentai|sakimichan|patron only|pornhub|.gg|xxxvideos|
          xvideos|retard|retarded|porno|deepfake|erection|thirst trap|erection|
          khyleri|dyke|anus|anal|blowjob|boner|cum|chink|chinky|paki|futanari|
          titjob|boobjob|scat|jizz|gangbang|chingchong|ziggaboo|mexcrement|
          kill yourself|kys|clit|orgasm|semen|foreskin|cock|ahegao|pedophile|
          pedophille|autist|pedos|gook|negro|rape|raper|rapist|slut|fellatio|
          cuck|.com|.org|.net|pussy|penis|uterus|cnc|bdsm|cunt|kink|kinky|discord.gg|
          join my server|thighs|th1ghs|smut|wanker|vulva|wank|titty|topless|tit|tits|swinger|
          hitler|swastika|strapon|spooge|jizz|shibari|cumshot|shemale|sex|chaturbate|scat|
          masochist|scissoring|schlong|shibari|sadism|raping|queef|pornography|pissing|pegging|
          pegged|paedophile|orgy|pedobear|ponyplay|nympho|nudes|nude|octopussy|omorashi|masturbate|
          milf|dilf|lolita|missionary|missionary style|m!ssionary style|m!ss!onary style|m!ss!0nary style|
          d0ggy style| kike|incest|nhentai|jailbait|handjob|g-spot|futanari|fisting|fingering|
          femdom|squirting|ecchi|ejaculation|erotic|doggiestyle|doggy style|doggystyle|deepthroat|
          date rape|daterape|dildo|clit|clitoris|camgirl|camslut|camwhore|butthole|anal|bitches|
          black cock|erotic|disboard|invite.gg|higger/i
}.freeze
