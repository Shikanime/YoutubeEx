use Mix.Config

config :youtube_ex_web, YoutubeExWeb.Endpoint,
  server: true,
  root: ".",
  version: Application.spec(:phoenix_distillery, :vsn)
