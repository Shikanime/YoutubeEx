defmodule YoutubeExApi.AuthenticationController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Accounts
  alias YoutubeEx.Accounts.User

  action_fallback YoutubeExApi.FallbackController

  def index(conn, auth_params) do
    login = Map.fetch!(auth_params, "login")
    password = Map.fetch!(auth_params, "password")

    with {:ok, %User{} = user} <- Accounts.authentitcate_user(login, password) do
      token = Phoenix.Token.sign(YoutubeExApi.Endpoint, "secret", user.id)

      conn
      |> put_status(:created)
      |> render("show.json", authentication: %{token: token, user: user})
    else
      {:error, :bad_credentials} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(YoutubeExApi.ErrorView)
        |> render("error.json", error:  %{password: "doesn't match"})
    end
  rescue
    e in KeyError ->
      conn
      |> put_status(:unprocessable_entity)
      |> put_view(YoutubeExApi.ErrorView)
      |> render("error.json", error:  Map.put(%{}, e.key, "can't be empty"))
  end
end
