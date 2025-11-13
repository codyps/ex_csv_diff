defmodule CsvDiff.MixProject do
  use Mix.Project

  def project do
    [
      app: :csv_diff,
      version: "0.1.0",
      elixir: "~> 1.18",
      licenses: ["Apache-2.0"],
      source_url: "https://github.com/codyps/ex_csv_diff",
      homepage_url: "https://github.com/codyps/ex_csv_diff",
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
