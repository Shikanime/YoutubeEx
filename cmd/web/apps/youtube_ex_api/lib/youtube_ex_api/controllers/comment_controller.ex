defmodule YoutubeExApi.CommentController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Activities
  alias YoutubeEx.Activities.Comment

  action_fallback YoutubeExApi.FallbackController

  def index(conn, _params) do
    comments = Activities.list_comments()
    render(conn, "index.json", comments: comments)
  end

  def create(conn, %{"comment" => comment_params}) do
    with {:ok, %Comment{} = comment} <- Activities.create_comment(comment_params) do
      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end

  def show(conn, %{"id" => id}) do
    comment = Activities.get_comment!(id)
    render(conn, "show.json", comment: comment)
  end

  def update(conn, %{"id" => id, "comment" => comment_params}) do
    comment = Activities.get_comment!(id)

    with {:ok, %Comment{} = comment} <- Activities.update_comment(comment, comment_params) do
      render(conn, "show.json", comment: comment)
    end
  end

  def delete(conn, %{"id" => id}) do
    comment = Activities.get_comment!(id)

    with {:ok, %Comment{}} <- Activities.delete_comment(comment) do
      send_resp(conn, :no_content, "")
    end
  end
end
