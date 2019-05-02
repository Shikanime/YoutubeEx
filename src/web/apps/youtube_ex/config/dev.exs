# Since configuration is shared in umbrella projects, this file
# should only configure the :youtube_ex application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# Cluster discovery
config :libcluster,
  gossip_secret: "7dpG02D6M/6GbzIVkgr46YuoPvKiau9jVnTMNE6AE4hA/vDFsHg6dxsV+y0VikpM"

# Configure your database
config :youtube_ex, YoutubeEx.Repo,
  username: "postgres",
  password: "postgres",
  database: "youtube_ex_dev",
  hostname: "localhost",
  pool_size: 10
