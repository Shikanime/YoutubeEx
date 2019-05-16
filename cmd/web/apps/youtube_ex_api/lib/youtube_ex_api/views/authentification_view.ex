defmodule YoutubeExApi.AuthenticationView do
  use YoutubeExApi, :view
  alias YoutubeExApi.UserView
  alias YoutubeExApi.AuthenticationView

  def render("show.json", %{authentication: authentication}) do
    %{message: "OK",
      data: render_one(authentication, AuthenticationView, "authentication.json")}
  end

  def render("authentication.json", %{authentication: authentication}) do
    %{token: authentication.token,
      user: render_one(authentication.user, UserView, "user.json")}
  end
end
