defmodule YoutubeExApi.UserView do
  use YoutubeExApi, :view
  alias YoutubeExApi.UserView

  def render("index.json", %{users: users}) do
    %{message: "OK",
      data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{message: "OK",
      data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      username: user.username,
      email: user.email,
      created_at: user.inserted_at}
  end
end
