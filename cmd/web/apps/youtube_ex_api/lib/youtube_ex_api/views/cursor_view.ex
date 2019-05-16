defmodule YoutubeExApi.CursorView do
  use YoutubeExApi, :view

  def render("cursor.json", %{cursor: cursor}) do
    %{current: cursor.current,
      total: cursor.total}
  end
end
