defmodule YoutubeExApi.VideoController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Contents
  alias YoutubeEx.Contents.Video

  action_fallback YoutubeExApi.FallbackController

  def index(conn, _params) do
    videos = Contents.list_videos()
    render(conn, "index.json", videos: videos)
  end

  def create(conn, %{"video" => video_params}) do
    {video_upload, video_params} = Map.pop(video_params, :source)

    case Path.extname(video_upload.filename) do
      extension when extension in [".mp4", ".avi"] ->
        File.cp(video_upload.path, "/media/#{video_params.id}#{extension}")

        with {:ok, %Video{} = video} <- Contents.create_video(video_params) do
          conn
          |> put_status(:created)
          |> render("show.json", video: video)
        end

      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("upload_fail.json", [])
    end
  end

  def show(conn, %{"id" => id}) do
    video = Contents.get_video!(id)
    render(conn, "show.json", video: video)
  end

  def update(conn, %{"id" => id, "video" => video_params}) do
    video = Contents.get_video!(id)

    with {:ok, %Video{} = video} <- Contents.update_video(video, video_params) do
      render(conn, "show.json", video: video)
    end
  end

  def delete(conn, %{"id" => id}) do
    video = Contents.get_video!(id)

    with {:ok, %Video{}} <- Contents.delete_video(video) do
      send_resp(conn, :no_content, "")
    end
  end
end
