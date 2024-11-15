FROM ruby:3.3-alpine

RUN apk update && \
    apk add --no-cache postgresql-dev ruby-json git build-base libsodium-dev ffmpeg

WORKDIR /app    

COPY . .

RUN gem install bundler --source https://rubygems.org && \
bundle install

CMD ["bundle", "exec", "ruby", "core.rb"]