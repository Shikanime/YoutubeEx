defmodule YoutubeExApi.UserVideoController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Accounts
  alias YoutubeEx.Contents
  alias YoutubeEx.Contents.Video

  action_fallback YoutubeExApi.FallbackController

  def index(conn, %{"id" => id}) do
    videos = Contents.list_user_videos(id)
    render(conn, "index.json", videos: videos)
  end

  def create(conn, %{"id" => id} = video_params) do
    with :ok <- Accounts.permit_create_video(conn.assigns.current_user.id, id) do
      {video_upload, video_params} = Map.pop(video_params, "source")

      case Path.extname(video_upload.filename) do
        ext when ext in [".mp4", ".avi"] ->
          uri = "/static/videos/#{video_params["id"]}/#{video_params["name"]}#{ext}"
          path = (:code.priv_dir(:youtube_ex_api) |> to_string()) <> uri
          dir = Path.dirname(path)

          with :ok <- File.mkdir_p(dir),
               :ok <- File.cp(video_upload.path, path) do
            video_params =
              video_params
              |> Map.put("user", id)
              |> Map.put("duration", 0)
              |> Map.put("source", uri)

            with {:ok, %Video{} = video} = Contents.create_video(video_params) do
              conn
              |> put_status(:created)
              |> render("show.json", video: video)
            end
          else
            {:error, _reason} ->
              conn
              |> put_status(:unprocessable_entity)
              |> render("400.json", code: "", error_stack: []) # TODO: Send stack error
          end

        _ ->
          conn
          |> put_status(:unprocessable_entity)
          |> render("400.json", code: "", error_stack: []) # TODO: Send stack error
      end
    end
  end
end
