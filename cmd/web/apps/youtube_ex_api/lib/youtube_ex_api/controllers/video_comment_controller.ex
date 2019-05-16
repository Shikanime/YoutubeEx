defmodule YoutubeExApi.VideoCommentController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Accounts
  alias YoutubeEx.Activities
  alias YoutubeEx.Activities.Comment

  action_fallback YoutubeExApi.FallbackController

  def index(conn, params) do
    index = Map.get(params, "page", 1)
    offset = Map.get(params, "perPage", 1)

    page = Activities.paginate_comments(index, offset)
    comments = %{entries: page.entries,
                 cursor: %{current: page.page_number,
                           total: page.total_pages}}
    conn
    |> put_view(YoutubeExApi.CommentView)
    |> render("index.json", comments: comments)
  end

  def create(conn, %{"id" => id} = comment_params) do
    with :ok <- Accounts.permit_comment_video(conn.assigns.current_user.id) do
      comment_params = Map.put(comment_params, "user_id", conn.assigns.current_user.id)
      comment_params = Map.put(comment_params, "video_id", id)

      with {:ok, %Comment{} = comment} <- Activities.create_comment(comment_params) do
        conn
        |> put_status(:created)
        |> put_view(YoutubeExApi.CommentView)
        |> render("show.json", comment: comment)
      end
    end
  end
end
