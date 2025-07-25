## Introduction

Frost is a personal Discord bot. It handles booster perks, birthday roles, and more.

## Installation

Ruby version 3.4, a PostgreSQL database, and Docker is needed to run the bot.

1. **Install the latest version of Ruby**

This should be fairly self-explanatory. See [here](https://www.ruby-lang.org/en/documentation/installation/) for detailed instructions.

2. **Install dependencies**

Simply do: `bundle install`.

3. **Create the database in PostgreSQL**

You'll need to be using PostgreSQL version 17 or higher. Type the following into the PostgreSQL manager:

```sql
CREATE ROLE frost WITH LOGIN PASSWORD 'urpassword';

CREATE EXTENSION IF NOT EXISTS pg_trgm; CREATE DATABASE tundra OWNER frost;
```

4. **Fill in configuration variables**

Change the name of the `example.yml` file to `config.yml` and fill in all the variables.

```yaml
# Discord related credentials.
Discord:
  TOKEN: "TOKEN_HERE"
  OWNER: "YOUR_ID_HERE"

# Manga chapter related credentials.
Chapter:
  LINK: ""
  CHANNEL: ""
  ELEMENT: ""

# the auto-moderation configuration.
Moderator:
  GUILD: ""
  CHANNEL: ""

# Database related credentials.
Postgres:
  URL: "postgres://URI_HERE"
```

Many of these variables are undocumented because the bot is meant for personal use.

5. **Run the bot**

Build the Dockerfile with `docker build . -t frost:latest --shm-size=2g`

## ToS and Privacy Policy

I'm required to have one of these. No private information is stored.
