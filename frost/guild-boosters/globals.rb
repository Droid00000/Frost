# frozen_string_literal: true

module Boosters
  # Interaction responses.
  REPLY = Frost::Utilities.table(
    BOOSTER_ROLE_CLAIM_SUCCESSFUL: "Your role has been created! You can always edit your role using the </booster role edit:1386237785865850941> command. <:AnyaPeek_Enzo:1276327731113627679>",
    BOT_MAX_ROLE_BELOW_HOIST_ROLE: "Your role couldn't be created. The bot doesn't have permission to move your role above this server's booster role.",
    BOOSTER_ROLE_DELETE_SUCCESSFUL: "Your role has been deleted! Feel free to make a new role at any time. <a:YorClap_Maomao:1287269908157038592>",
    BOOSTER_ROLE_NOT_FOUND: "Your role couldn't be found. Please use the </booster role claim:1386237785865850941> command to claim your role.",
    BOT_MAX_ROLE_BELOW_BOOSTER_ROLE_DELETE: "Your role couldn't be deleted. The bot's highest role is below your custom role.",
    BOT_MAX_ROLE_BELOW_BOOSTER_ROLE_EDIT: "Your role couldn't be edited. The bot's highest role is below your custom role.",
    BOOSTER_ROLE_EDIT_SUCCESSFUL: "Your role has been successfully edited! <a:LoidClap_Maomao:1276327798104920175>",
    BOOSTER_ROLE_DELETE_COOLDOWN: "Your role couldn't be deleted. A new role can only be deleted after 10 minutes.",
    USER_MISSING_CONFIGURE_PERMISSIONS: "You need to have the `manage roles` permission to do this.",
    GUILD_HOIST_ROLE_DELETED: "Your role couldn't be created. This server's hoist role was deleted.",
    GUILD_MAX_ROLE_LIMIT: "Your role couldn't be created. The maximum role limit has been reached.",
    MISSING_START_AND_END_COLORS: "Please provide a start **and** end color for your gradient.",
    MEMBER_BANNED_BOOSTER_PERKS: "You've been banned from using booster perks in this server.",
    MISSING_START_OR_END_COLORS: "Please provide a start **or** end color for your gradient.",
    MISSING_PERMISSIONS: "The bot needs to have the `manage roles` permission to do this.",
    BOOSTER_ROLE_NAME_DISALLOWED: "Your role name contains a word that cannot be used.",
    MEMBER_MISSING_BOOST: "You must be a server booster to use this command.",
    BOOSTER_ROLE_ALREADY_CLAIMED: "You've already claimed your custom role.",
    MISSING_START_COLOR: "Please provide a start color for your gradient.",
    MISSING_END_COLOR: "Please provide an end color for your gradient.",
    UNCONFIGURED_GUILD: "This server hasn't enabled booster perks."
  )

  # Pre-defined colors.
  COLORS = {
    "default" => 0,
    "aquamarine" => 8_388_564,
    "beige" => 16_119_260,
    "black" => 723_723,
    "blue" => 3_447_003,
    "brown" => 10_824_234,
    "chocolate" => 13_789_470,
    "coral" => 16_744_272,
    "crimson" => 14_423_100,
    "cyan" => 65_535,
    "dark_blue" => 2_123_412,
    "dark_cyan" => 35_723,
    "dark_gray" => 6_323_595,
    "dark_green" => 2_067_276,
    "dark_magenta" => 11_342_935,
    "dark_orange" => 11_027_200,
    "dark_red" => 10_038_562,
    "deep_pink" => 16_716_947,
    "fuchsia" => 15_418_782,
    "gold" => 15_844_367,
    "gray" => 8_421_504,
    "green" => 3_066_993,
    "green_yellow" => 11_403_055,
    "hot_pink" => 16_738_740,
    "indigo" => 4_915_330,
    "ivory" => 16_777_200,
    "khaki" => 15_787_660,
    "lavender" => 15_132_410,
    "light_blue" => 11_393_254,
    "light_green" => 9_498_256,
    "light_pink" => 16_758_465,
    "light_yellow" => 16_777_184,
    "lime" => 65_280,
    "magenta" => 15_277_667,
    "maroon" => 8_388_608,
    "midnight_blue" => 1_644_912,
    "navy" => 128,
    "olive" => 8_421_376,
    "orange" => 15_105_570,
    "orange_red" => 16_729_344,
    "orchid" => 14_315_734,
    "pale_green" => 10_025_880,
    "pink" => 15_418_783,
    "powder_blue" => 11_591_910,
    "purple" => 10_181_046,
    "red" => 15_158_332,
    "royal_blue" => 4_286_945,
    "salmon" => 16_416_882,
    "silver" => 12_632_256,
    "sky_blue" => 8_900_331,
    "tan" => 13_808_780,
    "teal" => 1_752_220,
    "turquoise" => 4_251_856,
    "violet" => 15_631_086,
    "white" => 16_777_215,
    "yellow" => 16_705_372,
    "blurple" => 5_793_266,
    "original_blurple" => 7_506_394,
    "baby_blue" => 9_031_664
  }.freeze

  # Regex for matching hex colors.
  HEX_COLOR_REGEX = /[0-9A-F]{6}\b/i

  # Regex for matching Discord emojis.
  CUSTOM_EMOJI_REGEX = /<a?:\w{2,32}:(\d{15,75})>/

  # Regex for normalizing unicode emojis.
  UNICODE_EMOJI_VARIANT_REGEX = /[\u{FE00}-\u{FE0F}]/

  # Regex for matching offensive language.
  ROLE_NAME_REGEX = /fag|f@g|bitch|b1tch|faggot|whore|wh0re|tranny|tr@nny|nigger|nigga|faggot|nibba|n1g|n1gger|nigaboo|n1gga|n i g g e r|n i g g a|@everyone|r34|porn|hentai|sakimichan|patron only|pornhub|\.gg|xxxvideos|xvideos|retard|retarded|porno|deepfake|erection|thirst trap|erection|khyleri|dyke|anus|anal|blowjob|boner|cum|chink|chinky|paki|futanari|titjob|boobjob|scat|jizz|gangbang|chingchong|ziggaboo|mexcrement|kill yourself|kys|clit|orgasm|semen|foreskin|cock|ahegao|pedophile|pedophille|autist|pedos|gook|negro|\brape|raper\b|rapist|slut|fellatio|cuck|\.com|\.org|\.net|pussy|penis|uterus|cnc|bdsm|cunt|kink|kinky|discord\.gg|join my server|thighs|th1ghs|smut|wanker|vulva|wank|titty|topless|\btit\b|tits|swinger|hitler|swastika|strapon|spooge|jizz|shibari|cumshot|shemale|sex|chaturbate|scat|masochist|scissoring|schlong|shibari|sadism|raping|queef|pornography|pissing|pegging|pegged|paedophile|orgy|pedobear|ponyplay|nympho|nudes|nude|octopussy|omorashi|masturbate|milf|dilf|lolita|missionary|missionary style|m!ssionary style|m!ss!onary style|m!ss!0nary style|d0ggy style| kike|incest|nhentai|jailbait|handjob|g-spot|futanari|fisting|fingering|femdom|squirting|ecchi|ejaculation|erotic|doggiestyle|doggy style|doggystyle|deepthroat|date rape|daterape|dildo|clit|clitoris|camgirl|camslut|camwhore|butthole|anal|bitches|black cock|erotic|disboard|invite\.gg|higger|nate higgers|gooner|kys|kms|s3x/i

  # Extract a 16-bit color code serialized as an integer.
  def self.extract_color(input)
    return if input.nil? || input.empty?

    if (value = input[HEX_COLOR_REGEX]&.to_i(16))
      value.zero? ? COLORS[:black] : value
    else
      COLORS[Frost::Utilities.to_snake_case(input)]
    end
  end

  # Extract a custom emoji as a file-like object or a unicode emoji.
  def self.extract_icon(event, settings)
    return unless (icon = event.options[:icon])

    if (custom_emoji = icon[CUSTOM_EMOJI_REGEX, 1])
      return if !settings.any_icon? && !event.guild.emoji(custom_emoji)

      endpoint = Discordrb::Assets::ENDPOINTS[:custom_emoji]

      http = Faraday.get(
        "#{format(endpoint, custom_emoji, 'png')}?size=128"
      )

      return http.success? ? StringIO.new(http.body, "rb") : nil
    end

    icon[Unicode::Emoji::REGEX]&.gsub(UNICODE_EMOJI_VARIANT_REGEX, "")
  end

  # Validate a role name for any harmful words or phrases. Strips diacritics.
  def self.invalid_role_name?(input)
    return true if input.nil? || input.empty?

    input.unicode_normalize(:nfkd).gsub(/\p{Mn}/, "").match?(ROLE_NAME_REGEX)
  end
end
