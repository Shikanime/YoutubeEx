defmodule YoutubeExApi.AuthView do
  use YoutubeExApi, :view
  alias YoutubeExApi.AuthView

  def render("index.json", %{auths: auths}) do
    %{message: "OK",
      data: render_many(auths, AuthView, "auth.json")}
  end

  def render("show.json", %{auth: auth}) do
    %{message: "OK",
      data: render_one(auth, AuthView, "auth.json")}
  end

  def render("auth.json", %{auth: auth}) do
    %{token: auth.token,
      user: auth.user}
  end
end
