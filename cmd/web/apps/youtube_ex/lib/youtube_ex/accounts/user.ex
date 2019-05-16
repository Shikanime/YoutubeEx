defmodule YoutubeEx.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias YoutubeEx.Accounts.Credential
  alias YoutubeEx.Accounts.Autorisation

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "users" do
    field :email, :string
    field :pseudo, :string
    field :username, :string

    has_one :credential, Credential, on_delete: :delete_all
    has_one :Autorisation, Autorisation, on_delete: :delete_all

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
