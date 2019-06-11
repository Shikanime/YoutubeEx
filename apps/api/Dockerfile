FROM elixir:1.8-alpine AS tool_base

# Elixir build toolchain
RUN apk update \
    && apk add --no-cache \
      git \
      build-base
RUN mix local.rebar --force \
    && mix local.hex --force

FROM tool_base AS build_base

# Default application directory
WORKDIR /workspace

# Pull dependencies
COPY mix.* ./
COPY apps/api/mix.exs apps/api/
COPY apps/gateway/mix.exs apps/gateway/
COPY apps/mixer/mix.exs apps/mixer/
RUN mix deps.get

# Pull dependency configurations
COPY config/ config/

# Precompile dependencies
ENV MIX_ENV=prod
RUN mix deps.compile

FROM build_base AS app_base

# Pull application code
COPY apps/api/lib/ apps/api/lib/
COPY apps/gateway/lib/ apps/gateway/lib/
COPY apps/mixer/lib/ apps/gateway/lib/

# Precompile applications
RUN mix compile

# Pull priv
COPY apps/api/priv/ apps/api/priv/

# Pull release configurations
COPY rel rel

# Create release
RUN mix release --name api --env prod --verbose

FROM alpine:3.9 AS runtime_base

# Erlang runtime requirement
RUN apk update \
    && apk add --no-cache \
      openssl \
      bash

# Copy docker entrypoint
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

FROM runtime_base

# Pull build
COPY --from=app_base /workspace/_build/prod/rel/api/releases/0.1.0/api.tar.gz ./

# Extract tarball
RUN tar -xf api.tar.gz --directory /usr/local \
    && rm api.tar.gz

# Gossip protocol
EXPOSE 45892

# EPMD
EXPOSE 4369

# BEAM VM mesh
EXPOSE 49200-49210

# HTTP
EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["api", "foreground"]
