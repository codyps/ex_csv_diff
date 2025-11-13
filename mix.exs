defmodule CsvDiff.MixProject do
  use Mix.Project

  @version "0.2.0"
  @source_url "https://github.com/codyps/ex_csv_diff"
  def project do
    [
      app: :csv_diff,
      version: @version,
      elixir: "~> 1.18",
      source_url: @source_url,
      homepage_url: @source_url,
      start_permanent: Mix.env() == :prod,
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  defp description() do
    "A fast CSV diffing library powered by the Rust csv-diff crate via Rustler."
  end

  defp package() do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url},
      files: [
        "lib",
        "native/nativecsvdiff/Cargo.*",
        "native/nativecsvdiff/src",
        ".cargo",
        "Cargo.*",
        "checksum-*.exs",
        "mix.exs"
      ]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:rustler, "~> 0.37.1", runtime: false, optional: true},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:rustler_precompiled, "~> 0.8.3", runtime: false}
    ]
  end
end
