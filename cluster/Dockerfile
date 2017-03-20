FROM ruby:2.3.0-alpine

RUN apk add -U wget \
    && gem install redis \
    && wget http://download.redis.io/redis-stable/src/redis-trib.rb \
    && chmod +x redis-trib.rb
