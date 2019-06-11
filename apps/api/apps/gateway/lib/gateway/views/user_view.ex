defmodule Gateway.UserView do
  use Gateway, :view
  alias Gateway.UserView
  alias Gateway.CursorView

  def render("index.json", %{users: users}) do
    %{message: "OK",
      data: render_many(users.entries, UserView, "user.json"),
      pager: render_one(users.cursor, CursorView, "cursor.json")}
  end

  def render("show.json", %{user: user}) do
    %{message: "OK",
      data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      email: user.email,
      pseudo: user.pseudo}
  end
end
