defmodule Gateway.CursorView do
  use Gateway, :view

  def render("cursor.json", %{cursor: cursor}) do
    %{current: cursor.current,
      total: cursor.total}
  end
end
