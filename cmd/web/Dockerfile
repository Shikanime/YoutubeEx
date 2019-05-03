FROM elixir:1.8-alpine AS build

# Elixir build toolchain
RUN apk update && \
  apk upgrade --no-cache
RUN apk add --no-cache \
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
COPY apps/youtube_ex/mix.exs apps/youtube_ex/
COPY apps/youtube_ex_web/mix.exs apps/youtube_ex_web/
COPY apps/youtube_ex_discovery/mix.exs apps/youtube_ex_discovery/
RUN mix deps.get

# Pull dependency configurations
COPY config/ config/
COPY apps/youtube_ex/config/ apps/youtube_ex/config/
COPY apps/youtube_ex_web/config/ apps/youtube_ex_web/config/
COPY apps/youtube_ex_discovery/config/ apps/youtube_ex_discovery/config/

# Set application environment
ARG MIX_ENV=prod
ENV MIX_ENV=${MIX_ENV}

# Precompile dependencies
RUN mix deps.compile

# Pull node dependencies
COPY apps/youtube_ex_web/assets/package.json apps/youtube_ex_web/assets/
COPY apps/youtube_ex_web/assets/yarn.lock apps/youtube_ex_web/assets/
RUN cd apps/youtube_ex_web/assets && \
  yarn install

# Pull and digest assets
COPY apps/youtube_ex_web/assets/ apps/youtube_ex_web/assets/
RUN cd apps/youtube_ex_web/assets/ && \
  yarn deploy
RUN cd apps/youtube_ex_web \
  mix phx.digest

# Pull application code
COPY apps/youtube_ex/lib/ apps/youtube_ex/lib/
COPY apps/youtube_ex_web/lib/ apps/youtube_ex_web/lib/
COPY apps/youtube_ex_discovery/lib/ apps/youtube_ex_web/lib/

# Precompile applications
RUN mix compile

# Pull priv
COPY apps/youtube_ex/priv/ apps/youtube_ex/priv/
COPY apps/youtube_ex_web/priv/ apps/youtube_ex_web/priv/

# Pull release configurations
COPY rel rel

# Set release environment
ARG REL_ENV=prod

# Create release
RUN mix release \
  --name youtube_ex \
  --env ${REL_ENV} \
  --verbose

FROM alpine:3.9

# Erlang runtime requirement
RUN apk update && \
  apk upgrade --no-cache
RUN apk add --no-cache \
  openssl \
  bash

ENV REPLACE_OS_VARS=true

# Gossip protocol
EXPOSE 45892

# EPMD
EXPOSE 4369

# BEAM VM mesh
EXPOSE 49200-49210

# Application environment
ARG MIX_ENV=prod

# Pull build
COPY --from=build /opt/youtube-ex/_build/${MIX_ENV}/rel/youtube_ex/releases/0.1.0/youtube_ex.tar.gz ./

# Extract tarball
RUN mkdir /opt/youtube-ex && \
  tar \
  -xf youtube_ex.tar.gz \
  --directory /opt/youtube-ex && \
  rm youtube_ex.tar.gz

# HTTP
EXPOSE 80

# Copy docker entrypoint
COPY docker-entrypoint.sh ./

ENTRYPOINT ["./docker-entrypoint.sh"]
CMD ["/opt/youtube-ex/bin/youtube_ex", "foreground"]
