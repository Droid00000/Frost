# frozen_string_literal: true

# 100 - The reason show in a guild's audit log whenever a role is created by the bot.

# 200 - The reason show in a guild's audit log whenever a role is updated by the bot.

# 201 — Fires upon successfully creating a role.

# 202 — Fires when the edit request was succesfully accepted by the client.

# 205 — Fires upon succesfully deleting a role.

# 226 — Fires when a role has already been claimed in that guild for that user.

# 300 - The reason show in a guild's audit log whenever a role is deleted by the bot.

# 301 - General response code when specific functionality hasn't been enabled in a server.

# 302 — General response code when a user has been banned from using specific functionality.

# 400 - General response code when the role name returns a false for the regex validation.

# 401 — General response code that fires when a user isn't a server booster.

# 404 — Fires when the client can't find a role. (User hasn't claimed role)

require 'toml-rb'

RESPONSE = {
  100 => 'Server booster claimed role.',
  200 => 'Server booster updated role.',
  201 => 'Your role has been created! You can always edit your role using the ``/booster role edit`` command.',
  202 => 'Your role has been successfully edited!',
  205 => 'Your role has been successfully deleted! Feel free to make a new role at any time.',
  226 => "You've already claimed your custom role in this server.",
  300 => 'Server booster deleted role.',
  301 => 'This functionality has not been enabled on this server.',
  302 => 'You have been banned from using this feature.',
  400 => 'Invalid name parameter.',
  401 => "You aren't boosting this server.",
  404 => "We couldn't find your role. Please use the ``/booster role claim`` command to claim your role.",
  405 => 'automatically update header channel upon chapter release.',
  500 => 'Made by *droid00000* using the [discordrb library!](<https://github.com/shardlab/discordrb>)'
}.freeze

# Emojis that the bot can use.

EMOJI = {
  10 => '<a:RubyPandaHeart:1269075581031546880>',
  20 => '<a:LoidClap_Maomao:1276327798104920175>',
  30 => '<:YorHeart_Alesetiawan:1276327768979804258>',
  40 => '<:AnyaPeek_Enzo:1276327731113627679>'
}.freeze

# UI components including color values, primarily used by the bot when sending embeds.

UI = {
  21 => 'https://cdn.discordapp.com/avatars/1268769768920580156/1551613008086970c244a81d043d354e?size=1024',
  22 => 0x8da99b,
  23 => 0x33363b,
  24 => 0x8da99b,
  25 => 0xd4f0ff
}.freeze

# Data used to update the status upon startup.

ACTIVITY = {
  50 => 'online',
  60 => 'https://github.com/Droid00000/Frost',
  70 => nil,
  80 => 'dnd',
  90 => 'Loading...'
}.freeze

# The TOML configuration file used by the bot.

TOML = TomlRB.load_file('../data/config.toml')

# A series of regular expressions utilized by the bot.

REGEX = {
  66 => /:(\d+)>$/,
  77 => /(?<=New chapter arrives on)(.*?)(?=<)/,
  88 => /^#/,
  99 => /fag|f@g|bitch|b1tch|faggot|whore|wh0re|tranny|tr@nny|nigger|
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
          black cock|erotic|disboard|invite.gg/i
}.freeze
