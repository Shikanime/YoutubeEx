defmodule Api.Search.Contents do
  alias Api.Search.Service

  def query_video(matchs \\ %{}) do
    body = %{query: %{match: matchs}}
    Service.post("/videos/_search", body)
  end

  def index_video(attrs \\ %{}) do
    Service.post("/videos/_doc", attrs)
  end
end
