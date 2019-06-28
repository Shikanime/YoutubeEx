defmodule Api.Encoding.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      :poolboy.child_spec(:worker, poolboy_config())
    ]

    opts = [strategy: :one_for_one, name: Api.Encoding.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp poolboy_config do
    [
      {:name, {:local, :python_encoder}},
      {:worker_module, Api.Encoding.PythonEncoder},
      {:size, 5},
      {:max_overflow, 3}
    ]
  end
end
