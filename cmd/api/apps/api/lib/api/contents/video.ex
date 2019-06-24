defmodule Api.Contents.Video do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.Contents.VideoFormat
  alias Api.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "videos" do
    field :duration, :integer
    field :enabled, :boolean, default: false
    field :name, :string
    field :source, :string
    field :view, :integer, default: 0

    belongs_to :user, User
    has_many :formats, VideoFormat

    timestamps()
  end

  def create_changeset(video, attrs) do
    video
    |> cast(attrs, [:name, :duration, :source, :view, :enabled, :user_id])
    |> validate_required([:name, :duration, :source, :view, :enabled, :user_id])
  end

  def update_changeset(video, attrs) do
    video
    |> cast(attrs, [:name, :duration, :source, :view, :enabled, :user_id])
  end
end
