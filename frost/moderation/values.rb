# frozen_string_literal: true

module Moderation
  # Responses and fields for moderation commands.
  RESPONSE = {
    1 => "The bot needs to have the `manage messages` permission to do this.",
    2 => "The bot needs to have the `view channel` permission to do this.",
    3 => "> **Deleted Messages:** %s\n> **ID:** `%s`",
    4 => "\n> **Member Since:** <t:%s:R>\n",
    5 => "Successfully deleted %s message",
    6 => "### Attachment Spammer",
    7 => "### Link Spammer"
  }.freeze

  # Roles that should be ignored by the automod.
  SAFE_ROLES = [
    580_598_801_144_741_895,
    603_376_323_175_383_061,
    981_274_581_404_889_129,
    603_125_756_519_907_338,
    739_460_673_779_531_808
  ].freeze

  # URLs that should be ignored by the auotmod.
  SAFE_LINKS = [
    "x.com",
    "redd.it",
    "viz.com",
    "java.com",
    "youtu.be",
    "imdb.com",
    "hulu.com",
    "tidal.com",
    "yahoo.com",
    "tenor.com",
    "imgur.com",
    "naver.com",
    "anilist.co",
    "python.org",
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
    "nohello.net",
    "discord.com",
    "spotify.com",
    "youtube.com",
    "twitter.com",
    "linkedin.com",
    "webtoons.com",
    "pintrest.com",
    "spotify.link",
    "facebook.com",
    "tryitands.ee",
    "ruby-lang.org",
    "w3schools.com",
    "m.youtube.com",
    "fxtwitter.com",
    "wikipedia.org",
    "vm.tiktok.com",
    "instagram.com",
    "codecademy.com",
    "m.webtoons.com",
    "old.rxddit.com",
    "ycombinator.com",
    "myanimelist.net",
    "music.apple.com",
    "sakugabooru.com",
    "open.spotify.com",
    "stackoverflow.com",
    "music.youtube.com",
    "player.spotify.com",
    "en.m.wikipedia.org",
    "animenewsnetwork.com",
    "mangaplus.shueisha.co.jp"
  ].freeze

  # Pluralize a string from the given integer.
  # @param string [String] The string to format.
  # @param sum [Integer] Any numeric integer.
  def self.plural(string, sum)
    "#{format(string, sum)}#{'s' if sum != 1}."
  end
end
