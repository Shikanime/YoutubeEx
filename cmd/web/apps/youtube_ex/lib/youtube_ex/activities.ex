defmodule YoutubeEx.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  alias YoutubeEx.Repo

  alias YoutubeEx.Activities.Comment

  def paginate_video_comments(id, opts \\ []) do
    opts = Keyword.new(opts, fn
      {:index, x}  -> {:page, x}
      {:offset, x} -> {:page_size, x}
      other -> other
    end)

    Comment
    |> where(video_id: ^id)
    |> Repo.paginate(opts)
  end

  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end
end
