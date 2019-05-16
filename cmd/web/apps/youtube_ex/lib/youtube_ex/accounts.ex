defmodule YoutubeEx.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias YoutubeEx.Repo

  alias YoutubeEx.Contents
  alias YoutubeEx.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def paginate_users(index, offset, pseudo) when is_nil(pseudo) do
    Repo.paginate(User, page: index, page_size: offset)
  end

  def paginate_users(index, offset, pseudo) do
    User
    |> where([u], like(u.pseudo, ^"%#{String.replace(pseudo, "%", "\\%")}%"))
    |> Repo.paginate(page: index, page_size: offset)
  end

  def get_user!(id), do: Repo.get!(User, id)

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  alias YoutubeEx.Accounts.Credential

  def authentitcate_user(login, password) do
    query = from u in User,
      where: u.email == ^login or u.username == ^login,
      preload: [:credential]

    with user <- Repo.one(query),
         false <- is_nil(user),
         true <- Argon2.verify_pass(password, user.credential.password)
    do
      {:ok, user}
    else
      _ ->
        {:error, :bad_credentials}
    end
  end

  alias YoutubeEx.Accounts.Autorisation

  def permit_show_user(user_id, id),
    do: verify_permission(user_id == id or can_user?(:show_user, user_id))

  def permit_update_user(user_id, id),
    do: verify_permission(user_id == id or can_user?(:update_user, user_id))

  def permit_delete_user(user_id, id),
    do: verify_permission(user_id == id or can_user?(:delete_user, user_id))

  def permit_create_video(user_id, id),
    do: verify_permission(user_id == id or can_user?(:create_video, user_id))

  def permit_update_video(video_id, user_id),
    do: verify_permission(Contents.get_video!(video_id).user_id == user_id or
                          can_user?(:update_video, user_id))

  def permit_delete_video(video_id, user_id),
    do: verify_permission(Contents.get_video!(video_id).user_id == user_id or
                          can_user?(:delete_video, user_id))

  def permit_create_video_format(video_id, user_id),
    do: verify_permission(Contents.get_video!(video_id).user_id == user_id or
                          can_user?(:create_video_format, user_id))

  def permit_comment_video(user_id),
    do: verify_permission(can_user?(:comment_video, user_id))

  def register_user(attrs \\ %{}) do
    user = User.changeset(%User{}, attrs)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:user, user)
    |> Ecto.Multi.insert(:credential, fn %{user: user} ->
      Ecto.build_assoc(user, :credential)
      |> Credential.changeset(attrs)
    end)
    |> Ecto.Multi.insert(:Autorisation, fn %{user: user} ->
      Ecto.build_assoc(user, :Autorisation)
      |> Autorisation.changeset(%{})
    end)
    |> Repo.transaction()
  end

  defp can_user?(permission, user_id) do
    query = from p in Autorisation,
      where: p.user_id == ^user_id and field(p, ^permission) == true

    Repo.exists?(query)
  end

  def verify_permission(condittion) do
    if condittion,
      do: :ok,
      else: {:error, :forbidden}
  end
end
