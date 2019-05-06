defmodule YoutubeExApi.AuthenticationController do
  use YoutubeExApi, :controller

  action_fallback YoutubeExApi.FallbackController

  def call(conn, _) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] -> verify_token(conn, token)
      _ -> {:error, :unauthorized}
    end
  end

  def verify_token(conn, token) do
    case Phoenix.Token.verify(YoutubeExApi.Endpoint, "secret", token, max_age: 86400) do
      {:ok, _} -> conn
      {:error, _} -> {:error, :forbidden}
    end
  end
end
