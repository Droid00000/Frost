FROM ruby:3.3-alpine

ENV TZ="America/Panama"

RUN apk update && \
    apk add --no-cache \
    postgresql-dev \
    ruby-json \
    git \
    build-base \
    firefox \
    ca-certificates \
    ttf-freefont

WORKDIR /app    

COPY . .

RUN bundle install

CMD ["bundle", "exec", "ruby", "core.rb"]