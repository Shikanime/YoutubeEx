defmodule YoutubeEx.Contents.Video do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "videos" do
    field :duration, :integer
    field :enabled, :boolean, default: false
    field :format, :map
    field :name, :string
    field :source, :string
    field :view, :integer
    field :user, :binary_id

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:name, :duration, :source, :view, :enabled, :format])
    |> validate_required([:name, :duration, :source, :view, :enabled, :format])
  end
end
