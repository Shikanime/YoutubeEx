defmodule Api.Accounts.Autorisation do
  use Ecto.Schema
  import Ecto.Changeset

  alias Api.Accounts.User

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "autorisations" do
    field :comment_video, :boolean, default: false
    field :create_video, :boolean, default: true
    field :create_video_format, :boolean, default: false
    field :delete_user, :boolean, default: false
    field :delete_video, :boolean, default: false
    field :update_user, :boolean, default: false
    field :update_video, :boolean, default: false

    belongs_to(:user, User)

    timestamps()
  end

  @doc false
  def changeset(autorisation, attrs) do
    autorisation
    |> cast(attrs, [
      :update_video,
      :delete_video,
      :create_video_format,
      :comment_video,
      :update_user,
      :delete_user,
      :create_video,
      :user_id
    ])
  end
end
