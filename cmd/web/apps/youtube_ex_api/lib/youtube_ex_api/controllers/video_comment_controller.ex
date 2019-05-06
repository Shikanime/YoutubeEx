defmodule YoutubeExApi.VideoCommentController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Activities
  alias YoutubeEx.Activities.Comment

  action_fallback YoutubeExApi.FallbackController

  def index(conn, _params) do
    comments = Activities.list_comments()
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"id" => id, "comment" => comment_params}) do
    comment_params = Map.put(comment_params, :user, id)

    with {:ok, %Comment{} = comment} <- Activities.create_comment(comment_params) do
      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end
end
