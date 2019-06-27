defmodule Api.Web.UserVideoController do
  use Api.Web, :controller

  alias Api.Web.Bucket
  alias Api.Accounts
  alias Api.Contents
  alias Api.Contents.Video
  alias Api.Search

  action_fallback Api.Web.FallbackController

  def index(conn, %{"id" => id} = params) do
    index = Map.get(params, "page", 1)
    offset = Map.get(params, "perPage", 1)

    page =
      Contents.paginate_user_videos(id,
        index: index,
        offset: offset
      )

    videos = %{
      entries: page.entries,
      cursor: %{current: page.page_number, total: page.total_pages}
    }

    conn
    |> put_view(Api.Web.VideoView)
    |> render("index.json", videos: videos)
  end

  def create(conn, %{"id" => id} = video_params) do
    file = Map.fetch!(video_params, "source")
    name = Map.fetch!(video_params, "name")

    with :ok <- Accounts.permit_create_video(conn.assigns.current_user.id),
         {:ok, video_path} <- Bucket.store_video(id, name, file) do
      video_params =
        video_params
        |> Map.delete("source")
        |> Map.put("user_id", conn.assigns.current_user.id)
        |> Map.put("duration", 0)
        |> Map.put("source", video_path)

      with {:ok, %Video{} = video} <- Contents.create_video(video_params),
           {:ok, _video} <- Search.Contents.index_video(video) do
        video = Map.put(video, :user, Accounts.get_user!(id))

        conn
        |> put_status(:created)
        |> put_view(Api.Web.VideoView)
        |> render("show.json", video: video)
      end
    else
      {:error, :unsupported_format} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(Api.Web.ErrorView)
        |> render("error.json", error: %{format: "is invalid"})

      other ->
        other
    end
  rescue
    e in KeyError ->
      conn
      |> put_status(:unprocessable_entity)
      |> put_view(Api.Web.ErrorView)
      |> render("error.json", error: Map.put(%{}, e.key, "can't be empty"))
  end
end
