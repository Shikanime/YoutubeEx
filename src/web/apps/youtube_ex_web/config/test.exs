# Since configuration is shared in umbrella projects, this file
# should only configure the :youtube_ex_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :youtube_ex_web, YoutubeExWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "ua5RqMwFrw8u+2SjIsB8AhDjW8gDw/qtsnJF3oRkX2qGOTrTyGgU0AMtPwl8H1MW",
  http: [port: 4002],
  server: false
