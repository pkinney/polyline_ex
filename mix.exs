defmodule Polyline.Mixfile do
  use Mix.Project

  def project do
    [
      app: :polyline,
      version: "1.6.0",
      elixir: "~> 1.12",
      description: description(),
      package: package(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      dialyzer: [plt_add_apps: [:poison, :mix]],
      deps: deps(),
      aliases: aliases(),

      # Docs
      name: "Polyline",
      docs: [
        main: "Polyline",
        source_ref: "master",
        source_url: "https://github.com/pkinney/polyline_ex"
      ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [extra_applications: [:logger]]
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
      {:benchfella, "~> 0.3", only: :dev},
      {:stream_data, "~> 1.1", only: :test},
      {:styler, "~> 1.3", only: [:dev, :test], runtime: false},
      {:credo, "~> 1.6", only: [:dev], runtime: false},
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false}
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
