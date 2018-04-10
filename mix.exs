defmodule Polyline.Mixfile do
  use Mix.Project

  def project do
    [
      app: :polyline,
      version: "0.1.2",
      elixir: "~> 1.2",
      description: description(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [applications: [:logger, :vector]]
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
      {:vector, "~> 0.1"},
      {:earmark, "~> 0.1", only: :dev},
      {:ex_doc, "~> 0.11", only: :dev},
      {:geo, "~> 1.0", only: :test},
      {:poison, "~> 2.0", only: :test},
      {:excoveralls, "~> 0.4", only: :test}
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
end
