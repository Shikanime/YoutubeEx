# Since configuration is shared in umbrella projects, this file
# should only configure the :youtube_ex_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :youtube_ex_web,
  ecto_repos: [YoutubeEx.Repo],
  generators: [context_app: :youtube_ex]

# Configures the endpoint
config :youtube_ex_web, YoutubeExWeb.Endpoint,
  render_errors: [view: YoutubeExWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: YoutubeExWeb.PubSub, adapter: Phoenix.PubSub.PG2]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
