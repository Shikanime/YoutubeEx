defmodule YoutubeEx.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias YoutubeEx.Repo

  alias YoutubeEx.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def auth_user(login, password) do
    user = Repo.get_by!(User, email: login)

    if Argon2.verify_pass(password, user.password),
      do: {:ok, user},
      else: {:error, :bad_credentials}
    rescue
      _ in Ecto.NoResultsError -> {:error, :unknow_user}
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
