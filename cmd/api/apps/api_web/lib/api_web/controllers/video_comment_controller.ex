defmodule Api.Web.VideoCommentController do
  use Api.Web, :controller

  alias Api.Accounts
  alias Api.Activities
  alias Api.Activities.Comment

  action_fallback Api.Web.FallbackController

  def index(conn, %{"id" => id} = comment_params) do
    index = Map.get(comment_params, "page", 1)
    offset = Map.get(comment_params, "perPage", 1)

    page =
      Activities.paginate_video_comments(id,
        index: index,
        offset: offset
      )

    comments = %{
      entries: page.entries,
      cursor: %{current: page.page_number, total: page.total_pages}
    }

    conn
    |> put_view(Api.Web.CommentView)
    |> render("index.json", comments: comments)
  end

  def create(conn, %{"id" => id} = comment_params) do
    with :ok <- Accounts.permit_comment_video(conn.assigns.current_user.id, id) do
      comment_params =
        comment_params
        |> Map.put("user_id", conn.assigns.current_user.id)
        |> Map.put("video_id", id)

      with {:ok, %Comment{} = comment} <- Activities.create_comment(comment_params) do
        conn
        |> put_status(:created)
        |> put_view(Api.Web.CommentView)
        |> render("show.json", comment: comment)
      end
    end
  end
end
