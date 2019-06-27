import Config

# Print only warnings and errors during test
config :logger, level: :warn

# ElasticSearch endpoint
config :api_search, Api.Search.Client, hostname: "localhost:9200"

# Configure your database
config :api, Api.Repo,
  username: "postgres",
  password: "postgres",
  database: "api_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :api_web, Api.Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ua5RqMwFrw8u+2SjIsB8AhDjW8gDw/qtsnJF3oRkX2qGOTrTyGgU0AMtPwl8H1MW",
  http: [port: 4002],
  server: false

# Cluster discovery
config :libcluster,
  gossip_secret: "S8mAcyw8nyfJcj6ixr6ffWUFgiLIWOhaFLc53vcDxG49Nzp2xVclTv+0veZbPQxI"
