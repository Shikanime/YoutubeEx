defmodule YoutubeEx.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias YoutubeEx.Repo

  alias YoutubeEx.Accounts.User
  alias YoutubeEx.Accounts.Credential

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

  def register_user(attrs \\ %{}) do
    user = User.changeset(%User{}, attrs)

    Ecto.Multi.new()
    |> Ecto.Multi.insert(:user, user)
    |> Ecto.Multi.insert(:credential, fn %{user: user} ->
      Ecto.build_assoc(user, :credential)
      |> Credential.changeset(attrs)
    end)
    |> Repo.transaction()
    |> IO.inspect()
  end

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

  alias YoutubeEx.Accounts.Policy

  def can_show_user?(id) do
    query = from p in Policy,
      where: p.user == ^id and p.show_user == true

    Repo.exists?(query)
  end

  def can_update_user?(id) do
    query = from p in Policy,
      where: p.user == ^id and p.pdate_user == true

    Repo.exists?(query)
  end

  def can_delete_user?(id) do
    query = from p in Policy,
      where: p.user == ^id and p.delete_user == true

    Repo.exists?(query)
  end

  def can_create_video?(id) do
    query = from p in Policy,
      where: p.user == ^id and p.create_video == true

    Repo.exists?(query)
  end
end
