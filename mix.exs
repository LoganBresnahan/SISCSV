defmodule SalesForceMarketingCloudCsvParser.MixProject do
  use Mix.Project

  def project do
    [
      app: :sales_force_marketing_cloud_csv_parser,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :nimble_csv]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_csv, "~> 0.3"},
      {:flow, "~> 0.14"},
      {:benchee, "~> 0.13", only: :dev}
    ]
  end

  defp escript do
    [
      main_module: SalesForceMarketingCloudCsvParser.Cli
    ]
  end
end
