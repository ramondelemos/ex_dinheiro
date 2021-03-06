defmodule Dinheiro.MixProject do
  use Mix.Project

  @version "0.3.0"
  @github_url "https://github.com/ramondelemos/ex_dinheiro"

  def project do
    [
      app: :ex_dinheiro,
      name: "Dinheiro",
      version: @version,
      elixir: "~> 1.6",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps(),
      docs: docs(),
      test_coverage: [tool: ExCoveralls],
      aliases: aliases()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:excoveralls, "~> 0.8.1", only: [:dev, :test]},
      {:ex_doc, "~> 0.18", only: [:dev, :docs], runtime: false},
      {:credo, "~> 0.8.10", only: [:dev, :test], runtime: false}
    ]
  end

  defp description do
    """
    Elixir library for money manipulation.
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Ramon de Lemos"],
      contributors: ["Ramon de Lemos"],
      licenses: ["MIT"],
      links: %{"GitHub" => @github_url}
    ]
  end

  def docs do
    [
      source_ref: "v#{@version}",
      source_url: @github_url,
      main: "Dinheiro",
      extras: ["README.md", "CHANGELOG.md"]
    ]
  end

  defp aliases do
    [
      build: [
        "clean",
        "docs",
        &set_env_to_test/1,
        "format",
        "credo --strict",
        "coveralls",
        "test"
      ],
      build_travis: [
        "build",
        "coveralls.travis"
      ]
    ]
  end

  defp set_env_to_test(_) do
    Mix.env(:test)
  end
end
