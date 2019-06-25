defmodule Api.Contents.VideoFormat do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.Contents.Video

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "video_formats" do
    field(:code, :string)
    field(:uri, :string)

    belongs_to(:video, Video)

    timestamps()
  end

  @doc false
  def changeset(video_format, attrs) do
    video_format
    |> cast(attrs, [:code, :uri, :video_id])
    |> validate_required([:code, :uri, :video_id])
  end
end
