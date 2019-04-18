defmodule Polyline.Mixfile do
  use Mix.Project

  def project do
    [
      app: :polyline,
      version: "1.2.1",
      elixir: "~> 1.3",
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
      {:vector, "~> 1.0"},
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.19", only: :dev},
      {:geo, "~> 3.0", only: :test},
      {:poison, "~> 4.0", only: :test},
      {:excoveralls, "~> 0.4", only: :test},
      {:dialyxir, "~> 0.4", only: [:dev], runtime: false}
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
