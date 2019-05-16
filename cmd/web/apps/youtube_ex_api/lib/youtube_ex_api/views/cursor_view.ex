defmodule YoutubeExApi.CursorView do
  use YoutubeExApi, :view
  alias YoutubeExApi.CursorView

  def render("cursor.json", %{cursor: cursor}) do
    %{current: cursor.current,
      total: cursor.total}
  end
end
