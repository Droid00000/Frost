## Introduction

Frost is a personal Discord bot. It handles booster roles, snowball fights, and more.

## Installation 

The most up-to-date release of the Ruby programming language, a PostgreSQL database, Docker, and all of the gems found below will need to be installed on your system.  

- [Sequel](https://github.com/jeremyevans/sequel)
- [Toml-rb](https://github.com/emancu/toml-rb)
- [Bundler](https://rubygems.org/gems/bundler/versions/2.5.18)
- [Faraday](https://github.com/lostisland/faraday)
- [Tempfile](https://github.com/ruby/tempfile)
- [Discordrb](https://github.com/shardlab/discordrb)
- [Require-All](https://github.com/jarmo/require_all)
- [Rufus-Scheduler](https://github.com/jmettraux/rufus-scheduler)
- [selenium-webdriver](https://rubygems.org/gems/selenium-webdriver)

1. **Install the latest version of Ruby**

This is needed for the bot to actually run.

2. **Install dependencies**

Simply do: `bundle install`.

3. **Create the database in PostgreSQL**

You'll need to be using PostgreSQL 14 or higher. If you want a hassle-free solution, [Neon](https://neon.tech/home) is a great choice. Type the following
in the PostgreSQL manager:

```sql
CREATE ROLE frost WITH LOGIN PASSWORD 'yourpasswordhere';
CREATE DATABASE frigid OWNER frost;
```

4. **Fill in configuration variables**

Change the name of the `example.toml` file to `config.toml` and fill in all the variables.

```ruby
[Discord]
OWNER = YOUR_ID_HERE
CONTRIBUTORS = []
RAW_TOKEN = "PLAIN_TOKEN_HERE"
BOT_TOKEN = "Bot REST_OF_THE_TOKEN_HERE"

[Postgres]
USERNAME = ""
PASSWORD = ""
URL = ""

[Chapter]
CHANNEL = ""
LINK = ""
```

Many of these variables are undocumented because the bot is meant for personal use.

## ToS and Privacy Policy

The only information stored is your user ID and the role ID of your role. Your role and user ID is deleted upon your booster role being removed.
