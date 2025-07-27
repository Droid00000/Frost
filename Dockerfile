FROM ruby:3.4-alpine

ENV TZ="Etc/UTC"

RUN apk add --no-cache \
    postgresql-dev \
    icu-data-full \
    libc6-compat \
    build-base \
    ruby-dev \
    firefox \
    tzdata \
    git

WORKDIR /app

COPY . .

RUN bundle install

CMD ["bundle", "exec", "ruby", "--yjit", "core.rb"]