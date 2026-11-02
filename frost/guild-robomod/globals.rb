# frozen_string_literal: true

module Moderation
  # Interaction responses.
  REPLY = Frost::Utilities.table(
    USER_MISSING_CONFIGURE_PERMISSIONS: "You need to have the `administrator` permission to do this."
  )

  # Content for alert messages.
  ELEMENTS = Frost::Utilities.table(
    SPAM_ALERT_PRIMARY_CONTENT: "> **Deleted Messages:** %s\n> **ID:** `%s`\n> **Member Since:** <t:%s:R>\n",
    ATTACHMENT_SPAM_ALERT_HEADER: "### Attachment Spammer",
    LINK_SPAM_ALERT_HEADER: "### Link Spammer"
  )

  # URLs that should be ignored by RoboMod.
  SAFE_LINKS = Set[
    "x.com",
    "redd.it",
    "viz.com",
    "java.com",
    "youtu.be",
    "imdb.com",
    "hulu.com",
    "ebay.com",
    "tidal.com",
    "yahoo.com",
    "tenor.com",
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
    "en.wikipedia.org",
    "ru.wikipedia.org",
    "fr.wikipedia.org",
    "zh.wikipedia.org",
    "pl.wikipedia.org",
    "ja.wikipedia.org",
    "de.wikipedia.org",
    "es.wikipedia.org",
    "it.wikipedia.org",
    "pt.wikipedia.org",
    "stackoverflow.com",
    "music.youtube.com",
    "ru.m.wikipedia.org",
    "fr.m.wikipedia.org",
    "zh.m.wikipedia.org",
    "pl.m.wikipedia.org",
    "ja.m.wikipedia.org",
    "de.m.wikipedia.org",
    "es.m.wikipedia.org",
    "it.m.wikipedia.org",
    "pt.m.wikipedia.org",
    "player.spotify.com",
    "en.m.wikipedia.org",
    "m.series.naver.com",
    "archiveofourown.org",
    "animenewsnetwork.com",
    "mangaplus.shueisha.co.jp"
  ].freeze

  # Format a duration in seconds into a human-readable format.
  def format_duration_seconds(seconds)
    weeks, leftover = seconds.divmod(604_800)
    days, leftover = leftover.divmod(86_400)
    hours, leftover = leftover.divmod(3_600)
    minutes, seconds_left = leftover.divmod(60)

    parts = []

    parts << "#{weeks} week#{'s' if weeks > 1}" if weeks.positive?
    parts << "#{days} day#{'s' if days > 1}" if days.positive?
    parts << "#{hours} hour#{'s' if hours > 1}" if hours.positive?
    parts << "#{minutes} minute#{'s' if minutes > 1}" if minutes.positive?

    if seconds_left.positive? || parts.empty?
      parts << "#{seconds_left} second#{'s' if seconds_left > 1}"
    end

    parts.join(", ")
  end
end
