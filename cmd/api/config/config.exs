# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

# Configures the endpoint
config :api_web, Api.Web.Endpoint,
  render_errors: [view: Api.Web.ErrorView, accepts: ~w(json)],
  pubsub: [name: Api.Web.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :api,
  ecto_repos: [Api.Repo]

# General application configuration
config :api_web,
  ecto_repos: [Api.Repo],
  generators: [context_app: :api, binary_id: true]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
