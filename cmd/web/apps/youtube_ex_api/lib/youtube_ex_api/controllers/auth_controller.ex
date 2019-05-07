defmodule YoutubeExApi.AuthController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Accounts
  alias YoutubeEx.Accounts.User

  action_fallback YoutubeExApi.FallbackController

  def create(conn, auth_params) do
    login = Map.fetch!(auth_params, "login")
    password = Map.fetch!(auth_params, "password")

    with {:ok, %User{} = user} <- Accounts.auth_user(login, password) do
      token = Phoenix.Token.sign(YoutubeExApi.Endpoint, "secret", user.id)

      conn
      |> put_status(:created)
      |> render("show.json", token: token)
    else
      {:error, :unknow_user} -> {:error, :unprocessable_entity}
    end
  rescue
    _ in KeyError ->
      {:error, :unprocessable_entity}
  end
end
