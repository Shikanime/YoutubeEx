defmodule Api.Activities.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.Accounts.User
  alias Api.Contents.Video

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "comments" do
    field(:body, :string)

    belongs_to(:user, User)
    belongs_to(:video, Video)

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:body, :user_id, :video_id])
    |> validate_required([:body, :user_id, :video_id])
  end
end
