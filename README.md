## Introduction

Frost is a personal Discord bot. It handles music, booster roles, snowball fights, and more.

## Installation

At least Ruby version 3.1, a PostgreSQL database, a LavaLink node, and Docker (optional) is needed to run the bot.

1. **Install the latest version of Ruby**

This should be fairly self-explanatory. See [here](https://www.ruby-lang.org/en/documentation/installation/) for instructions.

2. **Install dependencies**

Simply do: `bundle install`. Install: [ffmpeg](https://www.ffmpeg.org/download.html), [libsodium](https://github.com/shardlab/discordrb/wiki/Installing-libsodium), and [yt-dlp](https://github.com/yt-dlp/yt-dlp) for voice features.

3. **Create the database in PostgreSQL**

You'll need to be using PostgreSQL 14 or higher. If you want an easy solution, [Neon](https://neon.tech/home) is a great choice. Type the following
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
COMMANDS = []
CONTRIBUTORS = []

[Postgres]
URL = "postgres://URI_HERE"

[Chapter]
CHANNEL = ""
LINK = ""

[Lavalink]
ADDRESS = ""
PASSWORD = ""
```

Many of these variables are undocumented because the bot is meant for personal use.

5. **Run the bot**

Either build the Dockerfile, or to run locally do: `bundle exec ruby core.rb`.

## ToS and Privacy Policy

I'm required to have one of these. No private information is stored.
