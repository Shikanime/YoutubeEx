defmodule YoutubeEx.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias YoutubeEx.Accounts.Credential

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :pseudo, :string
    field :username, :string

    has_one :credential, Credential

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :pseudo])
    |> validate_required([:username, :email, :pseudo])
    |> unique_constraint(:email)
    |> unique_constraint(:pseudo)
  end
end
