defmodule YoutubeEx.Contents.Policy do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "content_policies" do
    field :create_video_format, :boolean, default: false
    field :delete_video, :boolean, default: false
    field :update_video, :boolean, default: false
    field :user, :binary_id

    timestamps()
  end

  @doc false
  def changeset(policy, attrs) do
    policy
    |> cast(attrs, [:update_video, :delete_video, :create_video_format])
    |> validate_required([:update_video, :delete_video, :create_video_format])
  end
end
