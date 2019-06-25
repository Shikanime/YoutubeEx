defmodule Api.Search.Contents do
  alias Api.Search.Client

  def query_video(matchs \\ %{}) do
    body = %{query: %{match: matchs}}
    Client.get("/videos/_search", body)
  end

  def index_video(attrs \\ %{}) do
    Client.put("/videos/_doc", attrs)
  end
end
