FROM ruby:2.6.5-alpine3.11

ENV HOME="/app"
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

WORKDIR $HOME

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
      gcc \
      g++ \
      less \
      libc-dev \
      libxml2-dev \
      linux-headers \
      make \
      nodejs \
      postgresql \
      postgresql-dev \
      tzdata \
      yarn && \
    apk add --virtual build-packs --no-cache \
      build-base \
      curl-dev

COPY Gemfile $HOME
COPY Gemfile.lock $HOME

RUN bundle install && \
    apk del build-packs

COPY . $HOME
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
