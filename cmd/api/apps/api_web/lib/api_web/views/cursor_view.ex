defmodule Api.Web.CursorView do
  use Api.Web, :view

  def render("cursor.json", %{cursor: cursor}) do
    %{current: cursor.current,
      total: cursor.total}
  end
end
