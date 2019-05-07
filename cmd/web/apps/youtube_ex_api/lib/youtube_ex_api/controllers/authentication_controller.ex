defmodule YoutubeExApi.AuthenticationController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Accounts

  def call(conn, _) do
    with {:ok, token} <- check_required_token(conn),
         {:ok, id}    <- extract_token_payload(token) do
      conn
      |> assign(:current_user, Accounts.get_user!(id))
    else
      {:error, _} ->
        conn
        |> YoutubeExApi.FallbackController.call({:error, :unauthorized})
        |> halt()
    end
  end

  def check_required_token(conn) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        {:ok, token}

      _ ->
        {:error, :missing_token}
    end
  end

  def extract_token_payload(token) do
    case Phoenix.Token.verify(YoutubeExApi.Endpoint, "secret", token, max_age: 86400) do
      {:error, :expired} -> {:error, :expired_token}
      {:error, :invalid} -> {:error, :invalid_token}
      other -> other
    end
  end
end
