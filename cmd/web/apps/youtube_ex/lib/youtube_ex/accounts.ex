defmodule YoutubeEx.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias YoutubeEx.Repo

  alias YoutubeEx.Accounts.User

  def list_users do
    Repo.all(User)
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
      where: u.email == ^login,
      preload: [:credential]

    user = Repo.one!(query)

    if Argon2.verify_pass(password, user.credential.password) do
      {:ok, user}
    else
      {:error, :bad_credentials}
    end
  end

  alias YoutubeEx.Accounts.Autorisation

  def permit_show_user(user_id),
    do: user_have_permission(:show_user, user_id)

  def permit_update_user(user_id, _),
    do: user_have_permission(:update_user, user_id)

  def permit_delete_user(user_id),
    do: user_have_permission(:delete_user, user_id)

  def permit_create_video(user_id),
    do: user_have_permission(:create_video, user_id)

  def permit_update_video(user_id),
    do: user_have_permission(:update_video, user_id)

  def permit_delete_video(user_id),
    do: user_have_permission(:delete_video, user_id)

  def permit_create_video_format(user_id),
    do: user_have_permission(:create_video_format, user_id)

  def permit_comment_video(user_id),
    do: user_have_permission(:comment_video, user_id)

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

  defp user_have_permission(permission, user_id) do
    query = from p in Autorisation,
      where: p.user == ^user_id and field(p, ^permission) == true

    if Repo.exists?(query),
      do: :ok,
      else: {:error, :forbidden}
  end
end
