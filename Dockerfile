FROM ruby:3.3

ENV TZ="America/Panama"

RUN apt-get update && \
    apt-get install -y \
    postgresql libpq-dev \
    ruby-dev \
    git \
    build-essential \
    firefox-esr && \
    apt-get clean

WORKDIR /app

COPY . .

RUN bundle install

CMD ["bundle", "exec", "ruby", "--yjit", "core.rb"]