defmodule YoutubeEx.Repo do
  use Ecto.Repo,
    otp_app: :youtube_ex,
    adapter: Ecto.Adapters.Postgres
  use Scrivener,
    page_size: 10

  def init(_type, config) do
    hostname =
      System.get_env("POSTGRES_HOST") ||
        config[:hostname]

    password =
      System.get_env("POSTGRES_PASSWORD") ||
        config[:password]

    config =
      config
      |> Keyword.put(:hostname, hostname)
      |> Keyword.put(:password, password)

    {:ok, config}
  end
end
