# Since configuration is shared in umbrella projects, this file
# should only configure the :youtube_ex application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

config :youtube_ex,
  ecto_repos: [YoutubeEx.Repo]

import_config "#{Mix.env()}.exs"
