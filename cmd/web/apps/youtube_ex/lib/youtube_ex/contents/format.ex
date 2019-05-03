defmodule YoutubeEx.Contents.Format do
  use Ecto.Schema
  import Ecto.Changeset
  alias YoutubeEx.Contents.Format

  embedded_schema do
    field :"1080", :string
    field :"133", :string
    field :"240", :string
    field :"360", :string
    field :"480", :string
    field :"720", :string
  end

  @doc false
  def changeset(%Format{} = format, attrs) do
    format
    |> cast(attrs, [:"1080", :"720", :"480", :"360", :"240", :"133"])
    |> validate_required([:"1080", :"720", :"480", :"360", :"240", :"133"])
  end
end
