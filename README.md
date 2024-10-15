## Introduction

Frost is a personal Discord bot. It handles booster roles, snowball fights, and more.

## Installation 

The most up-to-date release of the Ruby programming language, a PostgreSQL database, Docker, and all of the gems below will need to be installed.

- [Sequel](https://github.com/jeremyevans/sequel)
- [Toml-rb](https://github.com/emancu/toml-rb)
- [Bundler](https://rubygems.org/gems/bundler/versions/2.5.18)
- [Discordrb](https://github.com/shardlab/discordrb)
- [Require-All](https://github.com/jarmo/require_all)
- [Rufus-Scheduler](https://github.com/jmettraux/rufus-scheduler)
- [selenium-webdriver](https://rubygems.org/gems/selenium-webdriver)

1. **Install the latest version of Ruby**

This is needed for the bot to actually run.

2. **Install dependencies**

Simply do: `bundle install`. Install: [ffmpeg](https://www.ffmpeg.org/download.html), [libsodium](https://github.com/shardlab/discordrb/wiki/Installing-libsodium), and [yt-dlp](https://github.com/yt-dlp/yt-dlp) seperately for voice features.

3. **Create the database in PostgreSQL**

You'll need to be using PostgreSQL 14 or higher. If you want a hassle-free solution, [Neon](https://neon.tech/home) is a great choice. Type the following
into the PostgreSQL manager:

```sql
CREATE ROLE frost WITH LOGIN PASSWORD 'yourpasswordhere';
CREATE DATABASE frigid OWNER frost;
```

4. **Fill in configuration variables**

Change the name of the `example.toml` file to `config.toml` and fill in all the variables.

```ruby
[Discord]
OWNER = "YOUR_ID_HERE"
TOKEN = "Bot TOKEN_HERE"
CONTRIBUTORS = []

[Postgres]
USERNAME = ""
PASSWORD = ""
URL = ""

[Chapter]
CHANNEL = ""
LINK = ""
```

Many of these variables are undocumented because the bot is meant for personal use.

5. **Run the bot**

Either build the Dockerfile, or to run locally do: `bundle exec ruby core.rb`.

## ToS and Privacy Policy

I'm required to have one of these. No private information is stored.
