defmodule YoutubeEx.Repo do
  use Ecto.Repo,
    otp_app: :youtube_ex,
    adapter: Ecto.Adapters.Postgres

  def init(_type, config) do
    hostname =
      case System.get_env("POSTGRES_HOST") do
        nil -> config[:hostname]
        other -> other
      end

    password =
      case System.get_env("POSTGRES_PASSWORD") do
        nil -> config[:password]
        other -> other
      end

    config =
      config
      |> Keyword.put(:hostname, hostname)
      |> Keyword.put(:password, password)
      |> IO.inspect()

    {:ok, config}
  end
end
