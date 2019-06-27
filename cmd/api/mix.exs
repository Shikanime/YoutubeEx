defmodule Api.Umbrella.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      releases: releases(),
      deps: deps()
    ]
  end

  defp releases do
    [
      api: [
        include_executables_for: [:unix],
        include_erts: false,
        applications: [
          api: :permanent,
          api_search: :permanent,
          api_web: :permanent,
          api_encoding: :permanent
        ]
      ]
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 0.5", only: :dev, runtime: false}
    ]
  end
end
