defmodule YoutubeEx.Activities do
  @moduledoc """
  The Activities context.
  """

  import YoutubeEx.Repo.Helpers, warn: false
  import Ecto.Query, warn: false
  alias YoutubeEx.Repo

  alias YoutubeEx.Activities.Comment

  def paginate_video_comments(id, opts \\ []) do
    Comment
    |> where(video_id: ^id)
    |> with_pagination(opts)
  end

  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end
end
