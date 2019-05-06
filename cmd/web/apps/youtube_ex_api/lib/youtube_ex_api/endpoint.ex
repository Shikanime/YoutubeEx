defmodule YoutubeExApi.Endpoint do
  use Phoenix.Endpoint, otp_app: :youtube_ex_api

  def init(_type, config) do
    port =
      case System.get_env("PORT") do
        nil -> config[:http][:port]
        env -> String.to_integer(env)
      end

    host =
      System.get_env("HOST") ||
        config[:url][:host]

    secret_key_base =
      System.get_env("PHOENIX_SECRET") ||
        config[:secret_key_base]

    config =
      config
      |> Keyword.put(:http, [:inet6, port: port])
      |> Keyword.put(:url, host: host, port: port)
      |> Keyword.put(:secret_key_base, secret_key_base)

    {:ok, config}
  end

  socket "/socket", YoutubeExApi.UserSocket,
    websocket: true,
    longpoll: false

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/medias",
    from: "/medias",
    from: :youtube_ex_api,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_youtube_ex_api_key",
    signing_salt: "BlkoCmpC"

  plug YoutubeExApi.Router
end
