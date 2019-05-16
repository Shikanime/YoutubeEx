defmodule YoutubeEx.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  alias YoutubeEx.Repo

  alias YoutubeEx.Activities.Comment

  def list_comments do
    Repo.all(Comment)
  end

  def paginate_comments(index, offset) do
    Repo.paginate(Comment, page: index, page_size: offset)
  end

  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end
end
