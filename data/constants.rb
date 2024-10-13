# frozen_string_literal: true

require 'toml-rb'

# A response message to an interaction.
RESPONSE = {
  1 => 'Your role has been created! You can always edit your role using the ``/booster role edit`` command.',
  2 => 'Your role has been successfully edited!',
  3 => 'Your role has been successfully deleted! Feel free to make a new role at any time.',
  4 => "You've already claimed your custom role on this server.",
  5 => 'This functionality has not been enabled on this server.',
  6 => 'You have been banned from using this feature.',
  7 => 'Invalid name parameter.',
  8 => "You aren't boosting this server.",
  9 => "We couldn't find your role. Please use the ``/booster role claim`` command to claim your role.",
  10 => 'Made by *droid00000* using the [discordrb library!](<https://github.com/shardlab/discordrb>)',
  11 => 'Invalid status parameter.',
  12 => 'You must be a contributor to use this command.',
  13 => 'Successfully updated the status! Thank you for contributing to my bot!',
  14 => "You're out of snowballs! You can collect more using the ``/collect snowball`` command!",
  15 => 'You missed!',
  16 => "This user doesn't have any snowballs.",
  17 => 'That role cannot be updated.',
  18 => '``401: Unauthorized.``',
  19 => 'The bot has powered off.',
  20 => 'Succesfully archived one pinned message!',
  21 => "This user doesn't have enough snowballs.",
  22 => "Successfully set the archive channel to:"
}.freeze

# The audit log reason shown whenever the bot does something.
REASON = {
  1 => 'Server booster claimed role.',
  2 => 'Server booster updated role.',
  3 => 'Server booster deleted role.',
  4 => 'Auto-update chapter release date.',
  5 => 'Event winner updated role.'
}.freeze

# Emojis that the bot can use.
EMOJI = {
  1 => '<a:RubyPandaHeart:1269075581031546880>',
  2 => '<a:LoidClap_Maomao:1276327798104920175>',
  3 => '<a:YorClap_Maomao:1287269908157038592>',
  4 => '<:AnyaPeek_Enzo:1276327731113627679>'
}.freeze

# UI components including color values; primarily used by the bot when sending embeds.
UI = {
  1 => 'https://cdn.discordapp.com/avatars/1268769768920580156/1551613008086970c244a81d043d354e?size=1024',
  2 => 0x89abd2,
  3 => 0x33363b,
  4 => 0x8da99b,
  5 => 0xd4f0ff,
  6 => 0x4d94e8
}.freeze

# Data used to update the bot status upon startup.
ACTIVITY = {
  1 => 'online',
  2 => 'https://github.com/Droid00000/Frost',
  3 => nil,
  4 => 'dnd',
  5 => 'Loading...'
}.freeze

# The TOML configuration file used by the bot.
TOML = TomlRB.load_file(File.join(File.expand_path('..', __dir__), 'config.toml'))

# A series of regular expressions utilized by the bot.
REGEX = {
  1 => /:(\d+)>$/,
  2 => /(?<=New chapter arrives on)(.*?)(?=<)/,
  3 => /\A#?[0-9A-Fa-f]{3}([0-9A-Fa-f]{3})?\z/,
  4 => /fag|f@g|bitch|b1tch|faggot|whore|wh0re|tranny|tr@nny|nigger|
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
          milf|dilf|lolita|missionary style|m!ssionary style|m!ss!onary style|m!ss!0nary style|
          d0ggy style| kike|incest|nhentai|jailbait|handjob|g-spot|futanari|fisting|fingering|
          femdom|squirting|ecchi|ejaculation|erotic|doggiestyle|doggy style|doggystyle|deepthroat|
          date rape|daterape|dildo|clit|clitoris|camgirl|camslut|camwhore|butthole|anal|bitches|
          black cock|erotic|disboard|invite.gg|higger/i
}.freeze
