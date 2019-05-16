FROM elixir:1.8-alpine AS build

# Elixir build toolchain
RUN apk update && \
  apk upgrade --no-cache
RUN apk add --no-cache \
  git \
  build-base
RUN mix local.rebar --force && \
  mix local.hex --force

# Default application directory
WORKDIR /opt/youtube-ex

# Pull dependencies
COPY mix.* ./
COPY apps/youtube_ex/mix.exs apps/youtube_ex/
COPY apps/youtube_ex_api/mix.exs apps/youtube_ex_api/
COPY apps/youtube_ex_discovery/mix.exs apps/youtube_ex_discovery/
RUN mix deps.get

# Pull dependency configurations
COPY config/ config/
COPY apps/youtube_ex/config/ apps/youtube_ex/config/
COPY apps/youtube_ex_api/config/ apps/youtube_ex_api/config/
COPY apps/youtube_ex_discovery/config/ apps/youtube_ex_discovery/config/

# Set application environment
ARG MIX_ENV=prod
ENV MIX_ENV=${MIX_ENV}

# Precompile dependencies
RUN mix deps.compile

# Pull application code
COPY apps/youtube_ex/lib/ apps/youtube_ex/lib/
COPY apps/youtube_ex_api/lib/ apps/youtube_ex_api/lib/
COPY apps/youtube_ex_discovery/lib/ apps/youtube_ex_api/lib/

# Precompile applications
RUN mix compile

# Pull priv
COPY apps/youtube_ex/priv/ apps/youtube_ex/priv/

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
ENV MIX_ENV=${MIX_ENV}

# Copy docker entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

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

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/opt/youtube-ex/bin/youtube_ex", "foreground"]
