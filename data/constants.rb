# frozen_string_literal: true

require 'toml-rb'
require_relative 'spotify'

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
  22 => 'Successfully set the archive channel to:',
  23 => "You've already setup event perks for this role.",
  24 => 'Successfully setup event perks for this role:',
  25 => 'This user is already a booster in this server.',
  26 => 'Successfully added the following user to the database:',
  27 => "This user isn't boosting your server, or hasn't claimed their role.",
  28 => 'Successfully removed the following user from the database:',
  29 => 'This user has already been banned from using the booster perks functionality.',
  30 => 'Successfully banned the following user from using the booster perks functionality:',
  31 => "This user isn't banned from using the booster perks functionality.",
  32 => 'Successfully un-banned the following user from using the booster perks functionality:',
  33 => 'Successfully set your hoist-role to the following role:',
  34 => 'Booster perks are already disabled in this server.',
  35 => "Successfully disabled booster perks in this server.",
  36 => "This server hasn't enabled the pin archiver.",
  37 => "Successfully disabled the pin archiver in this server.",
  38 => "This server hasn't enabled event perks.",
  39 => "Successfully disabled event perks in this server.",
  40 => "The bot isn't in a voice channel!",
  41 => 'Successfully Disconnected!',
  42 => 'Stopped playback of the current song.',
  43 => "You're not in a voice channel!",
  44 => 'Please provide a valid song.',
  45 => 'Begining playback!',
  46 => 'Finished playback!'
}.freeze

# A list of values for embed responses.
EMBED = {
  1 => 'Sends a random GIF to hug a server member.',
  2 => 'Sends a random GIF to nom a server member.',
  3 => 'Sends a random GIF to poke a server member.',
  4 => 'Opens the general help menu.',
  5 => 'Shows some information about the bot.',
  6 => 'Sends a random GIF to tell a server member to go to sleep.',
  7 => 'Sends a random GIF to show your anger towards a server member.',
  8 => 'Allows the bot owner to shutdown the bot.',
  9 => 'Opens the booster perks help menu.',
  10 => 'sets up the event roles functionality.',
  11 => 'sets up the pin archiver.',
  12 => 'Opens the booster perks help menu in administrator mode.',
  13 => 'Manually adds a member to the booster database.',
  14 => 'Bans a member from using the booster perks feature in this server.',
  15 => 'Opens the help menu you are currently viewing.',
  16 => 'Unbans a member from using the booster perks feature in this server.',
  17 => 'Sets up the booster perks feature in this server. Run this command again to update your settings.',
  18 => 'Disables the booster perks feature in this server.',
  19 => 'Manually deletes a member from the booster database.',
  20 => 'Creates your custom role. Optionally, you may put a custom emoji in the icon option.',
  21 => 'Lets you edit your custom role. All parameters are optional.',
  22 => 'Deletes your custom role. You can make a new role at any time provided you keep boosting the server.',
  23 => "Stops the currently playing song and disconnects the bot from the voice channel if it's in one.",
  24 => 'Stops the currently playing song.',
  25 => "Opens the help menu you're currently viewing.",
  26 => 'Plays audio from a Youtube URL.'
}.freeze

# The audit log reason shown whenever the bot does something.
REASON = {
  1 => 'Server booster claimed role.',
  2 => 'Server booster updated role.',
  3 => 'Server booster deleted role.',
  4 => 'Auto-update chapter release date.',
  5 => 'Event winner updated role.',
  6 => 'Server booster stopped boosting.'
}.freeze

# Emojis that the bot can use.
EMOJI = {
  1 => '<a:RubyPandaHeart:1269075581031546880>',
  2 => '<a:LoidClap_Maomao:1276327798104920175>',
  3 => '<a:YorClap_Maomao:1287269908157038592>',
  4 => '<:AnyaPeek_Enzo:1276327731113627679>',
  5 => '<a:LoidDance_Maomao:1295667431674482741>',
  6 => '<a:LoidBell_Maomao:1295667609961758731>'
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

# The class used to convert Spotify URL's into YouTube links.
MUSIC = Music::Resolver.new(TOML['Music']['YOUTUBE'], TOML['Music']['CLIENT_ID'], TOML['Music']['CLIENT_SECRET'])

# A series of regular expressions utilized by the bot.
# REGEX[4] is used to ensure a name doesn't contain any bad words.
REGEX = {
  1 => /:(\d+)>$/,
  2 => /(?<=New chapter arrives on)(.*?)(?=<)/,
  3 => /\A#?[0-9A-Fa-f]{3}([0-9A-Fa-f]{3})?\z/,
  4 => %r{^(?:https?://)?(?:www\.)?(?:open\.)?spotify\.com/track/([^?\/]+)},
  5 => /^(?:https?:\/\/)?(?:www\.)?(?:youtu\.be|youtube\.com)/,
  6 => /fag|f@g|bitch|b1tch|faggot|whore|wh0re|tranny|tr@nny|nigger|
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
