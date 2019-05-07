defmodule YoutubeExApi.AuthController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Accounts
  alias YoutubeEx.Accounts.User

  action_fallback YoutubeExApi.FallbackController

  def authenticate(conn, auth_params) do
    login = Map.fetch!(auth_params, "login")
    password = Map.fetch!(auth_params, "password")

    with {:ok, %User{} = user} <- Accounts.authentitcate_user(login, password) do
      token = Phoenix.Token.sign(YoutubeExApi.Endpoint, "secret", user.id)
IO.inspect(user)
      conn
      |> put_status(:created)
      |> render("show.json", auth: %{token: token, user: user.id})
    else
      {:error, :bad_credentials} -> {:error, %{stack: %{
        password: "doesn't match"
      }}}
    end
  end
end
