defmodule Api.Web.VideoView do
  use Api.Web, :view
  alias Api.Web.VideoView
  alias Api.Web.VideoFormatView
  alias Api.Web.CursorView

  def render("index.json", %{videos: videos}) do
    %{message: "OK",
      data: render_many(videos.entries, VideoView, "video.json"),
      pager: render_one(videos.cursor, CursorView, "cursor.json")}
  end

  def render("show.json", %{video: video}) do
    %{message: "OK",
      data: render_one(video, VideoView, "video.json")}
  end

  def render("video.json", %{video: video}) do
    %{id: video.id,
      name: video.name,
      duration: video.duration,
      source: video.source,
      view: video.view,
      format: render_many(video.formats, VideoFormatView, "video_format.json"),
      user: video.user_id,
      enabled: video.enabled,
      created_at: video.inserted_at}
  end
end
