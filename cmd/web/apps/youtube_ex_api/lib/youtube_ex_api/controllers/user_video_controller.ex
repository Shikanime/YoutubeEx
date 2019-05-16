defmodule YoutubeExApi.UserVideoController do
  use YoutubeExApi, :controller

  alias YoutubeExApi.Bucket
  alias YoutubeEx.Accounts
  alias YoutubeEx.Contents
  alias YoutubeEx.Contents.Video

  action_fallback YoutubeExApi.FallbackController

  def index(conn, %{"id" => id} = params) do
    index = Map.get(params, "page", 1)
    offset = Map.get(params, "perPage", 1)
    page = Contents.list_user_videos(id, index, offset)

    videos = %{
        entries: page.entries,
        cursor: %{
          current: page.page_number,
          total: page.total_pages
        }
      }

    conn
    |> put_view(YoutubeExApi.VideoView)
    |> render("index.json", videos: videos)
  end

  def create(conn, %{"id" => id} = video_params) do
    case Map.pop(video_params, "source") do
      {nil, _} ->
        {:error, %{source: "can't be blank"}}

      {video_upload, video_params} -> (
        with :ok <- Accounts.permit_create_video(conn.assigns.current_user.id, id) do
          with {:ok, video_path} <- Bucket.store_video(id, video_params["name"], video_upload) do
            video_params =
              video_params
              |> Map.put("user_id", conn.assigns.current_user.id)
              |> Map.put("duration", 0)
              |> Map.put("source", video_path)

            with {:ok, %Video{} = video} <- Contents.create_video(video_params) do
              video = Map.put(video, :user, Accounts.get_user!(id))

              conn
              |> put_status(:created)
              |> put_view(YoutubeExApi.VideoView)
              |> render("show.json", video: video)
            end
          else
            {:error, :unsupported_format} ->
              {:error, %{format: "is invalid"}}

            {:error, _reason} ->
              {:error, %{source: "is invalid"}}
          end
        end
      )
    end
  end
end
