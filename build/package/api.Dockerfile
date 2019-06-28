FROM python:3 AS encoding_builder

WORKDIR /workspace/apps/api_encoding/priv/python
COPY ./apps/api_encoding/priv/python .

RUN pip install -r requirements.txt

FROM elixir:1.9 AS base_builder

# Elixir build tools
RUN apt update \
    && apt install -y git build-essential
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
COPY apps/api_encoding/mix.exs apps/api_encoding/mix.exs
COPY apps/api_web/mix.exs apps/api_web/mix.exs
RUN mix deps.get --only ${MIX_ENV} \
    && mix deps.compile

# Compile applications
COPY --from=encoding_builder \
     /workspace/apps/api_encoding/priv/python \
     /workspace/apps/api_encoding/priv/python
COPY . .
RUN mix release --quiet

FROM erlang:22

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
