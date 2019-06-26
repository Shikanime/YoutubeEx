defmodule Api.Search.Service do
  use Tesla.Builder

  @baseurl Application.get_env(:api_search, __MODULE__)[:hostname]

  plug Tesla.Middleware.BaseUrl, "http://#{@baseurl}"
  plug Tesla.Middleware.JSON
end
