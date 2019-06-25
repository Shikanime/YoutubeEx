defmodule Api.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.Accounts.Credential
  alias Api.Accounts.Autorisation

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :pseudo, :string
    field :username, :string

    has_one(:credential, Credential, on_delete: :delete_all)
    has_one(:autorisation, Autorisation, on_delete: :delete_all)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :pseudo])
    |> validate_required([:username, :email])
    |> unique_constraint(:email)
    |> unique_constraint(:username)
  end
end
