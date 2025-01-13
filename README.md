## Introduction

Frost is a personal Discord bot. It handle music, booster roles, snowball fights, and more.

## Installation

Ruby version 3.3, a PostgreSQL database, a Lavalink node, and Docker is needed to run the bot.

1. **Install the latest version of Ruby**

This should be fairly self-explanatory. See [here](https://www.ruby-lang.org/en/documentation/installation/) for instructions.

2. **Install dependencies**

Simply do: `bundle install`.

3. **Create the database in PostgreSQL**

You'll need to be using PostgreSQL 14 or higher. If you want an easy solution, [Neon](https://neon.tech/home) is a great choice. Type the following
into the PostgreSQL manager:

```sql
CREATE ROLE frost WITH LOGIN PASSWORD 'yourpasswordhere';
CREATE DATABASE frigid OWNER frost;
```

4. **Fill in configuration variables**

Change the name of the `example.yml` file to `config.yml` and `lavalink.yml` to `application.yml` and fill in all the variables.

```yaml
# Discord related credentials.
Discord:
  OWNER: "YOUR_ID_HERE"
  TOKEN: "Bot TOKEN_HERE"
  CONTRIBUTORS: []

# Information about the Lavalink node.
Lavalink:
  ID: ""
  URL: ""
  TOKEN: ""

# Leaving this one undocumented.
Chapter:
  CHANNEL: ""
  ELEMENT: ""
  LINK: ""

# Holds information about staff.
Houses:
  GUILD: ""
  STAFF: []

# Database related credentials.
Postgres:
  URL: "postgres://URI_HERE"
```

Many of these variables are undocumented because the bot is meant for personal use.

5. **Run the bot**

Either build the Dockerfile, or do: `bundle exec ruby --yjit core.rb`.

## ToS and Privacy Policy

I'm required to have one of these. No private information is stored.
