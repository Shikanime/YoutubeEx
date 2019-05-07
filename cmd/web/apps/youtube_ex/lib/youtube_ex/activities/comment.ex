defmodule YoutubeEx.Activities.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias YoutubeEx.Accounts.User
  alias YoutubeEx.Contents.Video

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field :body, :string

    belongs_to :user, User
    belongs_to :video, Video

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
