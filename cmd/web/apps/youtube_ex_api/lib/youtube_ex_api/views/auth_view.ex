defmodule YoutubeExApi.AuthView do
  use YoutubeExApi, :view
  alias YoutubeExApi.AuthView

  def render("index.json", %{tokens: tokens}) do
    %{message: "OK",
      data: render_many(tokens, AuthView, "token.json")}
  end

  def render("show.json", %{token: token}) do
    %{message: "OK",
      data: render_one(token, AuthView, "token.json")}
  end

  def render("token.json", %{token: token}) do
    %{data: %{id: token.id,
              token: token.token,
              user: token.user}}
  end
end
