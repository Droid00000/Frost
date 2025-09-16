# frozen_string_literal: true

# Resolvable string color codes.
COLORS = {
  aquamarine: 8_388_564,
  beige: 16_119_260,
  black: 723_723,
  blue: 3_447_003,
  brown: 10_824_234,
  chocolate: 13_789_470,
  coral: 16_744_272,
  crimson: 14_423_100,
  cyan: 65_535,
  dark_blue: 2_123_412,
  dark_cyan: 35_723,
  dark_gray: 6_323_595,
  dark_green: 2_067_276,
  dark_magenta: 11_342_935,
  dark_orange: 11_027_200,
  dark_red: 10_038_562,
  deep_pink: 16_716_947,
  fuchsia: 15_418_782,
  gold: 15_844_367,
  gray: 8_421_504,
  green: 3_066_993,
  green_yellow: 11_403_055,
  hot_pink: 16_738_740,
  indigo: 4_915_330,
  ivory: 16_777_200,
  khaki: 15_787_660,
  lavender: 15_132_410,
  light_blue: 11_393_254,
  light_green: 9_498_256,
  light_pink: 16_758_465,
  light_yellow: 16_777_184,
  lime: 65_280,
  magenta: 15_277_667,
  maroon: 8_388_608,
  midnight_blue: 1_644_912,
  navy: 128,
  olive: 8_421_376,
  orange: 15_105_570,
  orange_red: 16_729_344,
  orchid: 14_315_734,
  pale_green: 10_025_880,
  pink: 15_418_783,
  powder_blue: 11_591_910,
  purple: 10_181_046,
  red: 15_158_332,
  royal_blue: 4_286_945,
  salmon: 16_416_882,
  silver: 12_632_256,
  sky_blue: 8_900_331,
  tan: 13_808_780,
  teal: 1_752_220,
  turquoise: 4_251_856,
  violet: 15_631_086,
  white: 16_777_215,
  yellow: 16_705_372,
  blurple: 5_793_266,
  original_blurple: 7_506_394,
  baby_blue: 9_031_664,
  default: 0
}.freeze

# The YAML configuration file used by the bot.
CONFIG = YAML.load_file("#{File.expand_path('../..', __dir__)}/config.yml", symbolize_names: true)

# The Postgres database instance used by the bot.
POSTGRES = Sequel.connect(CONFIG[:Postgres][:URL], extensions: %i[connection_validator pg_streaming], max_connections: 5000, pool_timeout: 300)

# The extensions used by sequel and the database instance.
[POSTGRES.pool.connection_validation_timeout = -1, POSTGRES.stream_all_queries = true, POSTGRES.extension(:pg_array), Sequel.default_timezone = :utc]

# Regular expression patterns utilized by the bot.
REGEX = {
  1 => /([0-9A-Fa-f]{6})\b/i,
  2 => URI::RFC2396_PARSER.make_regexp,
  3 => /remove|off|disable|delete|null|nil/i,
  4 => /<(a?):([a-zA-Z0-9_]{1,32}):([0-9]{15,20})>/,
  5 => /fag|f@g|bitch|b1tch|faggot|whore|wh0re|tranny|tr@nny|nigger|nigga|faggot|nibba|n1g|n1gger|nigaboo|n1gga|n i g g e r|n i g g a|@everyone|r34|porn|hentai|sakimichan|patron only|pornhub|\.gg|xxxvideos|xvideos|retard|retarded|porno|deepfake|erection|thirst trap|erection|khyleri|dyke|anus|anal|blowjob|boner|cum|chink|chinky|paki|futanari|titjob|boobjob|scat|jizz|gangbang|chingchong|ziggaboo|mexcrement|kill yourself|kys|clit|orgasm|semen|foreskin|cock|ahegao|pedophile|pedophille|autist|pedos|gook|negro|rape|raper|rapist|slut|fellatio|cuck|\.com|\.org|\.net|pussy|penis|uterus|cnc|bdsm|cunt|kink|kinky|discord\.gg|join my server|thighs|th1ghs|smut|wanker|vulva|wank|titty|topless|tit|tits|swinger|hitler|swastika|strapon|spooge|jizz|shibari|cumshot|shemale|sex|chaturbate|scat|masochist|scissoring|schlong|shibari|sadism|raping|queef|pornography|pissing|pegging|pegged|paedophile|orgy|pedobear|ponyplay|nympho|nudes|nude|octopussy|omorashi|masturbate|milf|dilf|lolita|missionary|missionary style|m!ssionary style|m!ss!onary style|m!ss!0nary style|d0ggy style| kike|incest|nhentai|jailbait|handjob|g-spot|futanari|fisting|fingering|femdom|squirting|ecchi|ejaculation|erotic|doggiestyle|doggy style|doggystyle|deepthroat|date rape|daterape|dildo|clit|clitoris|camgirl|camslut|camwhore|butthole|anal|bitches|black cock|erotic|disboard|invite\.gg|higger|nate higgers|gooner|kys|kms|s3x/i
}.freeze
