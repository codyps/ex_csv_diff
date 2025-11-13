defmodule CsvDiff.MixProject do
  use Mix.Project

  def project do
    [
      app: :csv_diff,
      version: "0.1.0",
      elixir: "~> 1.18",
      source_url: "https://github.com/codyps/ex_csv_diff",
      homepage_url: "https://github.com/codyps/ex_csv_diff",
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
      links: %{"GitHub" => "https://github.com/codyps/ex_csv_diff"}
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:rustler, "~> 0.37.1", runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false}
    ]
  end
end
