# Since configuration is shared in umbrella projects, this file
# should only configure the :youtube_ex application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Cluster discovery
config :libcluster,
  gossip_secret: "S8mAcyw8nyfJcj6ixr6ffWUFgiLIWOhaFLc53vcDxG49Nzp2xVclTv+0veZbPQxI"

# Configure your database
config :youtube_ex, YoutubeEx.Repo,
  username: "postgres",
  password: "postgres",
  database: "youtube_ex_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
