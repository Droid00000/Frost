# frozen_string_literal: true

module Moderation
  # Responses and fields for moderation commands.
  RESPONSE = {
    1 => "> **Failed Messages:** %s\n> **Deleted Messages:** %s\n> **ID:** `%s`",
    2 => "The bot needs to have the `manage messages` permission to do this.",
    3 => "The bot needs to have the `view channel` permission to do this.",
    4 => "Successfully deleted %s message",
    5 => "**Attachment Spammer**"
  }.freeze

  # Roles that should be ignored by the automod.
  SAFE_ROLES = [
    603_376_323_175_383_061,
    984_381_256_018_055_268,
    603_125_756_519_907_338,
    739_460_845_263_650_920
  ].freeze

  # URLs that should be ignored by the auotmod.
  SAFE_LINKS = [
    "x.com",
    "redd.it",
    "viz.com",
    "youtu.be",
    "imdb.com",
    "hulu.com",
    "yahoo.com",
    "tenor.com",
    "imgur.com",
    "naver.com",
    "office.com",
    "netfix.com",
    "amazon.com",
    "rxddit.com",
    "tumblr.com",
    "google.com",
    "reddit.com",
    "tiktok.com",
    "github.com",
    "fixupx.com",
    "spotify.com",
    "youtube.com",
    "twitter.com",
    "webtoons.com",
    "pintrest.com",
    "spotify.link",
    "m.youtube.com",
    "fxtwitter.com",
    "wikipedia.org",
    "vm.tiktok.com",
    "instagram.com",
    "m.webtoons.com",
    "old.rxddit.com",
    "myanimelist.net",
    "music.apple.com",
    "sakugabooru.com",
    "open.spotify.com",
    "stackoverflow.com",
    "music.youtube.com",
    "en.m.wikipedia.org",
    "animenewsnetwork.com",
    "mangaplus.shueisha.co.jp",
    "cdn.discordapp.com/emojis"
  ].freeze

  # Pluralize a string from the given integer.
  # @param string [String] The string to format.
  # @param sum [Integer] Any numeric integer.
  def self.plural(string, sum)
    "#{format(string, sum)}#{'s' if sum != 1}."
  end
end
