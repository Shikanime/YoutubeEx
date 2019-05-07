defmodule YoutubeExApi.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use YoutubeExApi, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(YoutubeExApi.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn, {:error, %{} = detail}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(YoutubeExApi.ErrorView)
    |> render("error.json", detail)
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(YoutubeExApi.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, :forbidden}) do
    conn
    |> put_status(:forbidden)
    |> put_view(YoutubeExApi.ErrorView)
    |> render(:"403")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(YoutubeExApi.ErrorView)
    |> render(:"401")
  end

  def call(conn, {:error, :unprocessable_entity}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(YoutubeExApi.ErrorView)
    |> render("error.json", %{})
  end
end
