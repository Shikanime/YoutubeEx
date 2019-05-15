defmodule YoutubeEx.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  alias YoutubeEx.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "credentials" do
    field :password, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:password, :user_id])
    |> validate_required([:password, :user_id])
    |> put_change(:password, Argon2.hash_pwd_salt(attrs["password"]))
  end
end
