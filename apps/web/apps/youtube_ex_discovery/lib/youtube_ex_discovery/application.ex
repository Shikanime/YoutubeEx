defmodule YoutubeExDiscovery.Application do
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
        id: YoutubeExDiscovery.Cluster.Supervisor,
        start: {Cluster.Supervisor, :start_link, [[topologies]]},
        type: :supervisor
      }
      # Starts a worker by calling: YoutubeExDiscovery.Worker.start_link(arg)
      # {YoutubeExDiscovery.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: YoutubeExDiscovery.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
