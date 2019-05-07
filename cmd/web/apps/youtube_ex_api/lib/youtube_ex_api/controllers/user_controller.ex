defmodule YoutubeExApi.UserController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Accounts
  alias YoutubeEx.Accounts.User

  action_fallback YoutubeExApi.FallbackController

  def list(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def register(conn, user_params) do
    with {:ok, user_and_credential} <- Accounts.register_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: %{
        id: user_and_credential.user.id,
        username: user_and_credential.user.username,
        email: user_and_credential.user.email,
        pseudo: user_and_credential.user.pseudo
      })
    end
  end
  # def register(conn, user_params) do
  #   with {:ok, user}        <- Accounts.create_user(user_params),
  #        {:ok, _credential} <- Accounts.create_credential(user_params),
  #        {:ok, _policy}     <- Accounts.create_policy(%{id: user.id}),
  #        {:ok, _policy}     <- Activities.create_policy(%{id: user.id}),
  #        {:ok, _policy}     <- Contents.create_policy(%{id: user.id}) do
  #     conn
  #     |> put_status(:created)
  #     |> render("show.json", user: %{
  #       id: user.id,
  #       username: user.username,
  #       email: user.email,
  #       pseudo: user.pseudo
  #     })
  #   end
  # end


  def get(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id} = user_params) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
