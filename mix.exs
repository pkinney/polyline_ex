defmodule Polyline.Mixfile do
  use Mix.Project

  def project do
    [
      app: :polyline,
      version: "1.4.0",
      elixir: "~> 1.12",
      description: description(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      deps: deps(),
      aliases: aliases()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.19", only: :dev},
      {:geo, "~> 3.0", only: [:dev, :test]},
      {:poison, "~> 5.0", only: [:dev, :test]},
      {:excoveralls, "~> 0.4", only: :test},
      {:credo, "~> 1.5", only: [:dev], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false},
      {:benchfella, "~> 0.3", only: :dev},
      {:stream_data, "~> 0.5", only: :test}
    ]
  end

  defp description do
    """
    Encoding and decoding of Polylines
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*"],
      maintainers: ["Powell Kinney"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/pkinney/polyline_ex",
        "Docs" => "https://pkinney.github.io/polyline_ex/Polyline.html"
      }
    ]
  end

  defp aliases do
    [
      validate: [
        "clean",
        "compile --warnings-as-error",
        "format --check-formatted",
        "credo",
        "dialyzer"
      ]
    ]
  end
end
