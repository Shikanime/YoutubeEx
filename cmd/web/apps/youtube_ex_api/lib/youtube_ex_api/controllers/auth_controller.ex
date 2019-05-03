defmodule YoutubeExApi.AuthController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Accounts
  alias YoutubeEx.Accounts.Token

  action_fallback YoutubeExApi.FallbackController

  def create(conn, auth_params) do
    with {:ok, %Token{} = token} <- Accounts.auth_user(auth_params) do
      conn
      |> put_status(:created)
      |> render("show.json", token: token)
    end
  end
end
