defmodule YoutubeEx.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    gossip_secret =
      case System.get_env("GOSSIP_SECRET") do
        nil -> Application.get_env(:libcluster, :gossip_secret, "no-secret")
        other -> other
      end

    topologies = [
      replicas: [
        strategy: Cluster.Strategy.Gossip,
        config: [secret: gossip_secret]
      ]
    ]

    children = [
      %{
        id: YoutubeEx.ClusterSupervisor,
        start: {Cluster.Supervisor, :start_link, [[topologies]]},
        type: :supervisor
      },
      YoutubeEx.Repo
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: YoutubeEx.Supervisor)
  end
end
