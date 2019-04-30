FROM elixir:1.8-alpine AS build

# Elixir build toolchain
RUN apk update && \
  apk upgrade --no-cache
RUN apk update && \
  apk upgrade --no-cache && \
  apk add --no-cache \
  nodejs \
  yarn \
  git \
  build-base
RUN mix local.rebar --force && \
  mix local.hex --force

# Default application directory
WORKDIR /opt/youtube-ex

# Pull dependencies
COPY mix.* ./
COPY apps/youtube_ex/mix.exs apps/youtube_ex/mix.exs
COPY apps/youtube_ex_web/mix.exs apps/youtube_ex_web/mix.exs
RUN mix deps.get

# Pull dependency configurations
COPY config ./config
COPY apps/youtube_ex/config apps/youtube_ex/config
COPY apps/youtube_ex_web/config apps/youtube_ex_web/config

# Set application environment
ARG MIX_ENV=prod
ENV MIX_ENV=${MIX_ENV}

# Precompile dependencies
RUN mix deps.compile

# Pull and digest assets
COPY apps/youtube_ex_web/assets apps/youtube_ex_web/assets
RUN cd apps/youtube_ex_web/assets && \
  yarn install && \
  yarn deploy
RUN cd apps/youtube_ex_web \
  mix phx.digest

# Pull application code
COPY apps/youtube_ex/lib apps/youtube_ex/lib
COPY apps/youtube_ex_web/lib apps/youtube_ex_web/lib

# Precompile applications
RUN mix compile

# Pull priv
COPY apps/youtube_ex_web/priv apps/youtube_ex_web/priv
COPY apps/youtube_ex/priv apps/youtube_ex/priv

# Pull release configurations
COPY rel rel

# Set release environment
ARG REL_ENV=prod

# Create release
RUN mix release \
  --name youtube_ex \
  --executable \
  --env ${REL_ENV} \
  --verbose

FROM alpine:3.9

# Erlang runtime requirement
RUN apk update && \
  apk upgrade --no-cache
RUN apk add --no-cache \
  openssl \
  bash

# Default application directory
WORKDIR /opt/youtube-ex

ENV REPLACE_OS_VARS=true

# Gossip protocol
EXPOSE 45892

# EPMB
EXPOSE 4369

# BEAM VM mesh
EXPOSE 49200
EXPOSE 49201
EXPOSE 49202
EXPOSE 49203
EXPOSE 49204
EXPOSE 49205
EXPOSE 49206
EXPOSE 49207
EXPOSE 49208
EXPOSE 49209
EXPOSE 49210

# Application environment
ARG MIX_ENV=prod

# Pull build
COPY --from=build /opt/youtube-ex/_build/${MIX_ENV}/rel/youtube_ex/bin/youtube_ex.run .

# HTTP
EXPOSE 80

ENTRYPOINT ["/opt/youtube-ex/youtube_ex.run"]
CMD ["foreground"]
