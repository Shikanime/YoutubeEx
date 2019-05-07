defmodule YoutubeEx.Accounts.Policy do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "account_policies" do
    field :create_video, :boolean, default: false
    field :delete_user, :boolean, default: false
    field :get_user, :boolean, default: false
    field :update_user, :boolean, default: false
    field :user, :binary_id

    timestamps()
  end

  @doc false
  def changeset(policy, attrs) do
    policy
    |> cast(attrs, [:get_user, :update_user, :delete_user, :create_video])
    |> validate_required([:get_user, :update_user, :delete_user, :create_video])
  end
end
