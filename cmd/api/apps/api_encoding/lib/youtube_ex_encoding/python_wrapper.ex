defmodule Api.Encoding.PythonWrapper do
  @moduledoc """
  Just a wrapper for a Python instance
  """

  def start() do
    path = [:code.priv_dir(:api_encoding), "python"]
    joined_path = Path.join(path)

    {:ok, pid} = :python.start(python: 'python3', python_path: to_charlist(joined_path))
    pid
  end

  def call(pid, m, f, a \\ []) do
    :python.call(pid, m, f, a)
  end

  def cast(pid, message) do
    :python.cast(pid, message)
  end

  def stop(pid) do
    :python.stop(pid)
  end
end
