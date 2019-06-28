defmodule Api.Encoding do
  @moduledoc """
  Documentation for Api.Encoding.
  """

  @timeout 3000

  @doc """
  Checkout a worker from the poolboy pool and call the Python code
  """
  @spec register_video(String.t()) :: {:ok, pid} | {:error, atom}
  def register_video(filename) do
    worker = :poolboy.checkout(:python_encoder, @timeout)
    res = GenServer.call(worker, {:register_video, filename})

    case res do
      {:ok} ->
        {:ok, worker}

      error ->
        error
    end
  end

  @doc """
  Downsize the current video to smaller sizes
  Supported sizes: 1080p, 720p, 480p, 360p, 240p
  """
  @spec downsize_video(pid) :: term
  def downsize_video(worker) do
    GenServer.cast(worker, {:downsize_video})
  end

  @doc """
  Checkin a worker
  """
  @spec finalize_encoding(pid) :: term
  def finalize_encoding(worker) do
    :poolboy.checkin(:python_encoder, worker)
  end
end
