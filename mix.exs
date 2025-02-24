defmodule WaSomeBack.MixProject do
  use Mix.Project

  def project do
    [
      app: :wa_some_back,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {WaSomeBack.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.14"},
      {:plug_cowboy, "~> 2.0"},
      {:httpoison, "~> 1.8"}, 
      {:jason, "~> 1.4"},
      {:cors_plug, "~> 3.0"}
    ]
  end
end
