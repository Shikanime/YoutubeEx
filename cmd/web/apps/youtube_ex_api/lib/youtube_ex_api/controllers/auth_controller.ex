defmodule YoutubeExApi.AuthController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Accounts
  alias YoutubeEx.Accounts.User

  action_fallback YoutubeExApi.FallbackController

  def create(conn, auth_params) do
    login = Map.fetch!(auth_params, "login")
    password = Map.fetch!(auth_params, "password")

    with {:ok, %User{} = user} <- Accounts.auth_user(login, password),
         {:ok, token}          <- generate_and_register_token(user) do
      conn
      |> put_status(:created)
      |> render("show.json", token: token)
    end
  rescue
    _ in KeyError ->
      {:error, :unprocessable_entity}
  end

  defp generate_and_register_token(user) do
    token = Phoenix.Token.sign(YoutubeExApi.Endpoint, "secret", user.id)
    entry = %{
      user: user.id,
      token: token
    }

    with :ok <- Accounts.create_token(entry) do
      {:ok, token}
    end
  end
end
