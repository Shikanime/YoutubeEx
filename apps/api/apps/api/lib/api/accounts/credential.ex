defmodule Api.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.Accounts.User

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
    |> validate_length(:password, min: 6)
    |> put_password_hash()
  end

  ## Helpers

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password, Argon2.hash_pwd_salt(pass))

      _ ->
        changeset
    end
  end
end
