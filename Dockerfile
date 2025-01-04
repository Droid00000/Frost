FROM ruby:3.3-alpine

ENV TZ="America/Panama"

ENV DISCORDRB_NONACL="0"

RUN apk add --no-cache \
    postgresql-dev \
    icu-data-full \
    build-base \
    ruby-dev \
    firefox \
    git

WORKDIR /app

COPY . .

RUN bundle install

CMD ["bundle", "exec", "ruby", "--yjit", "core.rb"]