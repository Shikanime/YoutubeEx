defmodule Api.Encoding.PythonEncoder do
  @moduledoc false

  use GenServer
  alias Api.Encoding.PythonWrapper, as: Python

  #
  # Genserver callbacks
  #

  def start_link(_) do
    GenServer.start_link(__MODULE__, [])
  end

  @impl true
  def init(_args) do
    python_session = Python.start()
    {:ok, python_session}
  end

  #
  # Genserver behaviour
  #

  @impl true
  def handle_call({:register_video, filename}, from, state) do
    res = Python.call(state, :encoding, :register_video, [from, filename])
    {:reply, res, state}
  end

  @impl true
  def handle_cast({:downsize_video}, state) do
    Python.cast(state, :downsize_video)
    {:noreply, state}
  end
end
