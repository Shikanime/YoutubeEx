defmodule Api.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Api.Repo

  alias Api.Contents
  alias Api.Accounts.User

  def paginate_users_by_pseudo(pseudo, opts \\ []) do
    opts =
      Keyword.new(opts, fn
        {:index, x} -> {:page, x}
        {:offset, x} -> {:page_size, x}
        other -> other
      end)

    User
    |> where([u], like(u.pseudo, ^"%#{String.replace(pseudo, "%", "\\%")}%"))
    |> Repo.paginate(opts)
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

  alias Api.Accounts.Credential

  def authentitcate_user(login, password) do
    User
    |> by_login(login)
    |> preload(:credential)
    |> Repo.one!()
    |> verify_password(password)
  end

  defp verify_password(user, password) do
    if Argon2.verify_pass(password, user.credential.password) do
      {:ok, user}
    else
      {:error, :bad_credentials}
    end
  end

  alias Api.Accounts.Autorisation

  def create_user(attrs \\ %{}) do
    Repo.transaction(fn ->
      user =
        %User{}
        |> User.changeset(attrs)
        |> Repo.insert!()

      user
      |> Ecto.build_assoc(:credential)
      |> Credential.changeset(attrs)
      |> Repo.insert!()

      user
      |> Ecto.build_assoc(:autorisation)
      |> Autorisation.changeset(attrs)
      |> Repo.insert!()

      user
    end)
  rescue
    e in Ecto.InvalidChangesetError ->
      {:error, e.changeset}

    other ->
      {:error, other}
  end

  def permit_user(user_id, permission) do
    have_authorisation? =
      Autorisation
      |> where(user_id: ^user_id)
      |> filter_authorisation(permission)
      |> Repo.exists?()

    if have_authorisation? do
      :ok
    else
      {:error, :forbidden}
    end
  end

  def permit_show_user(id, id), do: :ok

  def permit_show_user(user_id, _),
    do: permit_user(user_id, :show_user)

  def permit_update_user(id, id), do: :ok

  def permit_update_user(user_id, _),
    do: permit_user(user_id, :update_user)

  def permit_delete_user(id, id), do: :ok

  def permit_delete_user(user_id, _),
    do: permit_user(user_id, :delete_user)

  def permit_create_video(user_id),
    do: permit_user(user_id, :create_video)

  def permit_update_video(user_id, video_id) do
    if user_own_video?(user_id, video_id) do
      :ok
    else
      permit_user(user_id, :update_video)
    end
  end

  def permit_delete_video(user_id, video_id) do
    if user_own_video?(user_id, video_id) do
      :ok
    else
      permit_user(user_id, :delete_video)
    end
  end

  def permit_create_video_format(user_id, video_id) do
    if user_own_video?(user_id, video_id) do
      :ok
    else
      permit_user(user_id, :create_video_format)
    end
  end

  def permit_comment_video(user_id, video_id) do
    if user_own_video?(user_id, video_id) do
      :ok
    else
      permit_user(user_id, :comment_video)
    end
  end

  defp user_own_video?(user_id, video_id) do
    video = Contents.get_video!(video_id)
    video.user_id == user_id
  end

  defp filter_authorisation(query, permission) do
    from(p in query,
      where: field(p, ^permission) == true
    )
  end

  defp by_login(query, login) do
    from(u in query,
      where: u.email == ^login or u.username == ^login
    )
  end
end
