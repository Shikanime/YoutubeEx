defmodule Api.Search.Client do
  use Tesla.Builder

  @baseurl Application.get_env(:api, :hostname)

  plug Tesla.Middleware.BaseUrl, @baseurl
  plug Tesla.Middleware.JSON
end
