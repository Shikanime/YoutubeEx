# Since configuration is shared in umbrella projects, this file
# should only configure the :youtube_ex application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Configure your database
config :youtube_ex, YoutubeEx.Repo,
  username: "postgres",
  password: "postgres",
  database: "youtube_ex_dev",
  hostname: "localhost",
  pool_size: 10
