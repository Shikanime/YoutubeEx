defmodule YoutubeEx.Contents.Video do
  use Ecto.Schema
  import Ecto.Changeset

  alias YoutubeEx.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "videos" do
    field :duration, :integer
    field :enabled, :boolean, default: false
    field :format, :map
    field :name, :string
    field :source, :string
    field :view, :integer, default: 0

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:name, :duration, :source, :view, :enabled, :format])
    |> validate_required([:name, :duration, :source, :view, :enabled, :format])
  end
end
