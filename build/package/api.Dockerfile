# syntax=docker/dockerfile:experimental

FROM erlang:22-alpine AS base_builder

# Install Elixir
ENV ELIXIR_VERSION="v1.9.0"
ENV LANG=C.UTF-8

RUN set -xe \
    && ELIXIR_DOWNLOAD_URL="https://github.com/elixir-lang/elixir/archive/${ELIXIR_VERSION}.tar.gz" \
    && ELIXIR_DOWNLOAD_SHA256="dbf4cb66634e22d60fe4aa162946c992257f700c7db123212e7e29d1c0b0c487" \
    && buildDeps=' \
    ca-certificates \
    make \
    ' \
    && apk add --no-cache --virtual .build-deps $buildDeps \
    && wget $ELIXIR_DOWNLOAD_URL \
    && echo "$ELIXIR_DOWNLOAD_SHA256  ${ELIXIR_VERSION}.tar.gz" | sha256sum -c - \
    && mkdir -p /usr/local/src/elixir \
    && tar -xzC /usr/local/src/elixir --strip-components=1 -f ${ELIXIR_VERSION}.tar.gz \
    && rm ${ELIXIR_VERSION}.tar.gz \
    && cd /usr/local/src/elixir \
    && make install clean \
    && apk del .build-deps

# Elixir build tools
RUN --mount=type=cache,target=/var/cache/apk \
    apk update \
    && apk add git build-base
RUN mix local.rebar --force \
    && mix local.hex --force

# Environment configurations
WORKDIR /workspace
ARG MIX_ENV=prod
ENV MIX_ENV=${MIX_ENV}

# Pull dependencies
COPY mix.* ./
COPY apps/api/mix.exs apps/api/mix.exs
COPY apps/api_search/mix.exs apps/api_search/mix.exs
COPY apps/api_web/mix.exs apps/api_web/mix.exs
RUN --mount=type=ssh \
    --mount=type=cache,target=/workspace/deps \
    mix deps.get --only ${MIX_ENV} \
    && mix deps.compile

# Compile applications
COPY . .
RUN mix release --quiet

FROM erlang:22-alpine

WORKDIR /opt/api

# Pull build
COPY --from=base_builder \
    /workspace/_build/prod/rel/api \
    /opt/api
ENV PATH=/opt/api/bin:$PATH

# Gossip
EXPOSE 45892

# EPMD
EXPOSE 4369

# BEAM VM mesh
EXPOSE 49200-49210

# HTTP
EXPOSE 80

CMD ["api", "start"]
