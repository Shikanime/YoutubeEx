defmodule YoutubeExApi.UserController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Accounts
  alias YoutubeEx.Accounts.User

  action_fallback YoutubeExApi.FallbackController

  def index(conn, user_params) do
    index = Map.get(user_params, "page", 1)
    offset = Map.get(user_params, "perPage", 1)
    pseudo = Map.fetch!(user_params, "pseudo")

    page = Accounts.paginate_users_by_pseudo(pseudo,
             index: index,
             offset: offset)

    users = %{entries: page.entries,
              cursor: %{current: page.page_number,
                        total: page.total_pages}}
    render(conn, "index.json", users: users)
  end

  def create(conn, user_params) do
    with {:ok, user} <- Accounts.create_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    with :ok <- Accounts.permit_show_user(conn.assigns.current_user.id, id) do
      user = Accounts.get_user!(id)
      render(conn, "show.json", user: user)
    end
  end

  def update(conn, %{"id" => id} = user_params) do
    with :ok <- Accounts.permit_update_user(conn.assigns.current_user.id, id) do
      user = Accounts.get_user!(id)

      with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
        render(conn, "show.json", user: user)
      end
    end
  end

  def delete(conn, %{"id" => id}) do
    with :ok <- Accounts.permit_delete_user(conn.assigns.current_user.id, id) do
      user = Accounts.get_user!(id)

      with {:ok, %User{}} <- Accounts.delete_user(user),
        do: send_resp(conn, :no_content, "")
    end
  end
end
