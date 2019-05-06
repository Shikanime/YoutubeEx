defmodule YoutubeExApi.AuthController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Accounts
  alias YoutubeEx.Accounts.User

  action_fallback YoutubeExApi.FallbackController

  def create(conn, auth_params) do
    with {:ok, %User{} = user} <- Accounts.auth_user(auth_params) do
      {:ok, conn, token} = register_token(conn, user)

      conn
      |> put_status(:created)
      |> render("show.json", token: token)
    end
  end

  def register_token(conn, user) do
    conn
    |> Phoenix.Token.sign(conn, "secret", user.id)

    {:ok, conn, ""}
  end
end
