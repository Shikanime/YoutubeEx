defmodule YoutubeExApi.CommentView do
  use YoutubeExApi, :view
  alias YoutubeExApi.CommentView
  alias YoutubeExApi.CursorView

  def render("index.json", %{comments: comments}) do
    %{message: "OK",
      data: render_many(comments.entries, CommentView, "comment.json"),
      pager: render_one(comments.cursor, CursorView, "cursor.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{message: "OK",
      data: render_one(comment, CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{id: comment.id,
      body: comment.body}
  end
end
