defmodule YoutubeExApi.AuthenticationController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Accounts
  alias YoutubeEx.Accounts.User

  action_fallback YoutubeExApi.FallbackController

  def authenticate(conn, auth_params) do
    login = Map.get(auth_params, "login")
    password = Map.get(auth_params, "password")

    with {:ok, %User{} = user} <- Accounts.authentitcate_user(login, password) do
      token = Phoenix.Token.sign(YoutubeExApi.Endpoint, "secret", user.id)

      conn
      |> put_status(:created)
      |> render("show.json", authentication: %{token: token, user: user})
    else
      {:error, :bad_credentials} ->
        {:error, %{password: "doesn't match"}}
    end
  end
end
