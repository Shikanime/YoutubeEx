defmodule YoutubeExApi.VideoController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Accounts
  alias YoutubeEx.Contents
  alias YoutubeEx.Contents.Video
  alias YoutubeEx.Contents.VideoFormat

  action_fallback YoutubeExApi.FallbackController

  def index(conn, _params) do
    videos = Contents.list_videos()
    render(conn, "index.json", videos: videos)
  end

  def show(conn, %{"id" => id}) do
    video = Contents.get_video!(id)
    render(conn, "show.json", video: video)
  end

  def update(conn, %{"id" => id, "video" => video_params}) do
    if Accounts.user_can_update_video?(conn.assigs.current_user.id) do
      video = Contents.get_video!(id)

      with {:ok, %Video{} = video} <- Contents.update_video(video, video_params) do
        render(conn, "show.json", video: video)
      end
    else
      {:error, :forbidden}
    end
  end

  def encode(conn, %{"id" => id} = video_params) do
    if Accounts.user_can_create_video_format?(conn.assigs.current_user.id) do
      {video_upload, video_params} = Map.pop(video_params, :source)

      case Path.extname(video_upload.filename) do
        extension when extension in [".mp4", ".avi"] ->
          File.cp(video_upload.path, "/media/#{video_params.id}#{extension}")

          video_params =
            Map.new(fn
              :format -> :code
              other -> other
            end)
            |> Map.put(:video, id)

          with {:ok, %VideoFormat{} = video} <- Contents.create_video_format(video_params) do
            render(conn, "show.json", video: video)
          end

        _ ->
          conn
          |> put_status(:unprocessable_entity)
          |> render("400.json", code: "", error_stack: []) # TODO: Send stack error
      end
    else
      {:error, :forbidden}
    end
  end

  def delete(conn, %{"id" => id}) do
    if Accounts.user_can_delete_video?(conn.assigs.current_user.id) do
      video = Contents.get_video!(id)

      with {:ok, %Video{}} <- Contents.delete_video(video) do
        send_resp(conn, :no_content, "")
      end
    else
      {:error, :forbidden}
    end
  end
end
