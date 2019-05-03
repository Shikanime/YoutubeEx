defmodule YoutubeExApi.VideoView do
  use YoutubeExApi, :view
  alias YoutubeExApi.VideoView

  def render("index.json", %{videos: videos}) do
    %{message: "OK",
      data: render_many(videos, VideoView, "video.json")}
  end

  def render("show.json", %{video: video}) do
    %{message: "OK",
      data: render_one(video, VideoView, "video.json")}
  end

  def render("video.json", %{video: video}) do
    %{message: "OK",
      data: %{id: video.id,
              name: video.name,
              duration: video.duration,
              source: video.source,
              view: video.view,
              user: video.user,
              enabled: video.enabled,
              format: video.format,
              created_at: video.created_at}}
  end

  def render("upload_fail.json", _assigns) do
    %{errors: "Unvalid video format"}
  end
end
