defmodule YoutubeExApi.VideoFormatView do
  use YoutubeExApi, :view

  def render("video_format.json", %{video_format: video_format}) do
    IO.inspect(video_format)
    Map.put(%{}, video_format.code, video_format.uri)
    |> IO.inspect()
  end
end
