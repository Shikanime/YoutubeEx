defmodule YoutubeEx.Contents.VideoFormat do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "video_formats" do
    field :code, :string
    field :uri, :string
    field :video, :binary_id

    timestamps()
  end

  @doc false
  def changeset(video_format, attrs) do
    video_format
    |> cast(attrs, [:code, :uri])
    |> validate_required([:code, :uri])
  end
end
