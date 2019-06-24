defmodule Api.Web.VideoController do
  use Api.Web, :controller

  alias Api.Web.Bucket
  alias Api.Accounts
  alias Api.Contents
  alias Api.Contents.Video

  action_fallback Api.Web.FallbackController

  def index(conn, video_params) do
    index = Map.get(video_params, "page", 1)
    offset = Map.get(video_params, "perPage", 1)

    page = Contents.paginate_videos(
             index: index,
             offset: offset)

    videos = %{entries: page.entries,
               cursor: %{current: page.page_number,
                         total: page.total_pages}}
    render(conn, "index.json", videos: videos)
  end

  def show(conn, %{"id" => id}) do
    video = Contents.get_video!(id)
    with {:ok, _} <- Contents.update_video(video, %{view: video.view + 1}),
      do: render(conn, "show.json", video: video)
  end

  def update(conn, %{"id" => id} = video_params) do
    with :ok <- Accounts.permit_update_video(id, conn.assigns.current_user.id) do
      video = Contents.get_video!(id)

      with {:ok, %Video{} = video} <- Contents.update_video(video, video_params),
        do: render(conn, "show.json", video: video)
    end
  end

  def patch(conn, %{"id" => id} = video_params) do
    file = Map.fetch!(video_params, "source")
    name = Map.fetch!(video_params, "name")
    format = Map.fetch!(video_params, "format")

    with :ok      <- Accounts.permit_create_video_format(conn.assigns.current_user.id, id),
         {:ok, uri} <- Bucket.store_video(id, name, file, format: format)
    do
      video_params =
        video_params
        |> Map.put("user_id", conn.assigns.current_user.id)
        |> Map.put("code", format)
        |> Map.put("uri", uri)

      with {:ok, %Video{} = video} <- Contents.create_video_format(id, video_params),
        do: render(conn, "show.json", video: video)
    else
      {:error, :unsupported_format} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(Api.Web.ErrorView)
        |> render("error.json", error:  %{format: "is invalid"})

      {:error, :unsupported_format} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(Api.Web.ErrorView)
        |> render("error.json", error:  %{source: "is invalid"})

      other -> other
    end
  rescue
    e in KeyError ->
      conn
      |> put_status(:unprocessable_entity)
      |> put_view(Api.Web.ErrorView)
      |> render("error.json", error:  Map.put(%{}, e.key, "can't be empty"))
  end

  def delete(conn, %{"id" => id}) do
    with :ok <- Accounts.permit_delete_video(id, conn.assigns.current_user.id) do
      video = Contents.get_video!(id)

      with {:ok, %Video{}} <- Contents.delete_video(video),
        do: send_resp(conn, :no_content, "")
    end
  end
end
