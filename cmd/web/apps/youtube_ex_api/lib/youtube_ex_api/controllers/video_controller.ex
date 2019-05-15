defmodule YoutubeExApi.VideoController do
  use YoutubeExApi, :controller

  alias YoutubeExApi.Bucket
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
    with :ok <- Accounts.permit_update_video(conn.assigns.current_user.id) do
      video = Contents.get_video!(id)

      with {:ok, %Video{} = video} <- Contents.update_video(video, video_params) do
        render(conn, "show.json", video: video)
      end
    end
  end

  def encode(conn, %{"id" => id} = video_params) do
    case Map.pop(video_params, "source") do
      {nil, _} -> (
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", error_stack: [
          source: "can't be blank"
        ])
      )

      {video_upload, video_params} -> (
        with :ok <- Accounts.permit_create_video_format(conn.assigns.current_user.id) do
          with {:ok, _} <- Bucket.store_video(id, video_params["name"], video_upload, format: video_params.format) do
            video_params = Map.put(video_params, "user", id)

            with {:ok, %VideoFormat{} = video} <- Contents.create_video_format(video_params) do
              render(conn, "show.json", video: video)
            end
          else
            {:error, _reason} ->
              conn
              |> put_status(:unprocessable_entity)
              |> render("error.json", error_stack: [
                source: "is invalid"
              ])
          end
        end
      )
    end
  end

  def delete(conn, %{"id" => id}) do
    with :ok <- Accounts.permit_delete_video(conn.assigns.current_user.id) do
      video = Contents.get_video!(id)

      with {:ok, %Video{}} <- Contents.delete_video(video) do
        send_resp(conn, :no_content, "")
      end
    end
  end
end
