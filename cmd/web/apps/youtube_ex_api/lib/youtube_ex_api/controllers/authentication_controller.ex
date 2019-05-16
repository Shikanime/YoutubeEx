defmodule YoutubeExApi.AuthenticationController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Accounts
  alias YoutubeEx.Accounts.User

  action_fallback YoutubeExApi.FallbackController

  def authenticate(conn, auth_params) do
    with {:ok, login} <- Map.fetch(auth_params, "login"),
         {:ok, password} <- Map.fetch(auth_params, "password"),
         {:ok, %User{} = user} <- Accounts.authentitcate_user(login, password)
    do
      token = Phoenix.Token.sign(YoutubeExApi.Endpoint, "secret", user.id)

      conn
      |> put_status(:created)
      |> render("show.json", authentication: %{token: token, user: user})
    else
      {:error, :bad_credentials} ->
        {:error, %{password: "doesn't match"}}

      :error ->
        {:error, %{message: "Invalid parameters"}}
    end
  end
end
