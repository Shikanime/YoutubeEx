defmodule YoutubeExApi.AuthenticationController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Accounts
  alias YoutubeEx.Accounts.Token

  def call(conn, _) do
    with {:ok, token} <- check_required_token(conn),
         {:ok, id}    <- extract_token_payload(token),
         :ok          <- verify_token_registry(id) do
      conn
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

  def verify_token_registry(id) do
    try do
      Accounts.get_token!(id)
      {:ok, Accounts.get_user!(id)}
    rescue
      e in Ecto.NoResultsError ->
        {:ok, :unregistred_token}
    end
  end
end
