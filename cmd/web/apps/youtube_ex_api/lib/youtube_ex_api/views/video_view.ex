defmodule YoutubeExApi.VideoView do
  use YoutubeExApi, :view
  alias YoutubeExApi.UserView
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
    IO.inspect(video)
    %{id: video.id,
      name: video.name,
      duration: video.duration,
      source: video.source,
      view: video.view,
      user: render_one(video.user, UserView, "user.json"),
      enabled: video.enabled,
      created_at: video.inserted_at}
  end
end
