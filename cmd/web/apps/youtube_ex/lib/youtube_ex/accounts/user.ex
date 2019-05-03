defmodule YoutubeEx.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :password, :string
    field :pseudo, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :pseudo, :password])
    |> validate_required([:username, :email, :pseudo, :password])
    |> unique_constraint(:email)
    |> unique_constraint(:pseudo)
    |> put_change(:password, Argon2.hash_pwd_salt(user.password))
  end
end
