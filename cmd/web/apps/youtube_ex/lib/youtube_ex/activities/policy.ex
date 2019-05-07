defmodule YoutubeEx.Activities.Policy do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "activity_policies" do
    field :comment_video, :boolean, default: false
    field :user, :binary_id

    timestamps()
  end

  @doc false
  def changeset(policy, attrs) do
    policy
    |> cast(attrs, [:comment_video])
    |> validate_required([:comment_video])
  end
end
