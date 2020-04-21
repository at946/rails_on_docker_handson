ARG BUILD_MODE="dev"
FROM ruby:2.6.5-alpine3.11

ARG BUILD_MODE
ARG PROD_MODE="prod"
ARG RUNTIME_PACKAGES="gcc \
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
                      yarn"
ARG BUILD_PACKAGES="build-base \
                    curl-dev"
ARG CHROME_PACKAGES="chromium \
                     chromium-chromedriver \
                     dbus \
                     mesa-dri-swrast \
                     ttf-freefont \
                     udev \
                     wait4ports \
                     xorg-server \
                     xvfb \
                     zlib-dev"

ENV HOME="/app"
ENV LANG=C.UTF-8
ENV TZ=Asia/Tokyo

WORKDIR $HOME

RUN apk update && \
    apk upgrade && \
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --virtual build-packs --no-cache ${BUILD_PACKAGES} && \
    if [ "${BUILD_MODE}" != "${PROD_MODE}" ]; then \
        apk add --no-cache ${CHROME_PACKAGES}; \
    fi

COPY Gemfile ${HOME}
COPY Gemfile.lock ${HOME}

RUN if [ "${BUILD_MODE}" = "${PROD_MODE}" ]; then \
        bundle install --without development test -j4; \
    else \
        bundle install --without production -j4; \
    fi && \
    apk del build-packs

COPY . ${HOME}

RUN if [ "${BUILD_MODE}" = "${PROD_MODE}" ]; then \
        bundle exec rails assets:precompile RAILS_ENV=production; \
    else \
        yarn install; \
    fi

EXPOSE 3000
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]