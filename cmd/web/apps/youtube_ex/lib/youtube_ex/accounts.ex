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

  def user_can_show_user?(id) do
    query = from p in Autorisation,
      where: p.user == ^id and p.show_user == true

    Repo.exists?(query)
  end

  def user_can_update_user?(id) do
    query = from p in Autorisation,
      where: p.user == ^id and p.update_user == true

    Repo.exists?(query)
  end

  def user_can_delete_user?(id) do
    query = from p in Autorisation,
      where: p.user == ^id and p.delete_user == true

    Repo.exists?(query)
  end

  def user_can_create_video?(id) do
    query = from p in Autorisation,
      where: p.user == ^id and p.create_video == true

    Repo.exists?(query)
  end

  def user_can_update_video?(id) do
    query = from p in Autorisation,
      where: p.user == ^id and p.update_video == true

    Repo.exists?(query)
  end

  def user_can_delete_video?(id) do
    query = from p in Autorisation,
      where: p.user == ^id and p.delete_video == true

    Repo.exists?(query)
  end

  def user_can_create_video_format?(id) do
    query = from p in Autorisation,
      where: p.user == ^id and p.create_video_format == true

    Repo.exists?(query)
  end

  def user_can_comment_video?(id) do
    query = from p in Autorisation,
      where: p.user == ^id and p.comment_video == true

    Repo.exists?(query)
  end

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
end
