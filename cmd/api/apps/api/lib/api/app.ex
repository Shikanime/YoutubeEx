defmodule Api.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    gossip_secret =
      System.get_env("GOSSIP_SECRET") ||
        Application.get_env(:libcluster, :gossip_secret, "no-secret")

    topologies = [
      replicas: [
        strategy: Cluster.Strategy.Gossip,
        config: [secret: gossip_secret]
      ]
    ]

    # List all child processes to be supervised
    children = [
      %{
        id: Api.Cluster.Supervisor,
        start: {Cluster.Supervisor, :start_link, [[topologies]]},
        type: :supervisor
      },
      Api.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Api.Supervisor)
  end
end
