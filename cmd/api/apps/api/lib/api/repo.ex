defmodule Api.Repo do
  use Ecto.Repo,
    otp_app: :api,
    adapter: Ecto.Adapters.Postgres
  use Scrivener

  def truc do
    Application.get_env(:api, __MODULE__)
  end
end
