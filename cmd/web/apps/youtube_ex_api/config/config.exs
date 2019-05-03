# Since configuration is shared in umbrella projects, this file
# should only configure the :youtube_ex_api application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :youtube_ex_api,
  ecto_repos: [YoutubeEx.Repo],
  generators: [context_app: :youtube_ex, binary_id: true]

# Configures the endpoint
config :youtube_ex_api, YoutubeExApi.Endpoint,
  render_errors: [view: YoutubeExApi.ErrorView, accepts: ~w(json)],
  pubsub: [name: YoutubeExApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
