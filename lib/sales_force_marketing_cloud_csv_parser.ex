defmodule SalesForceMarketingCloudCsvParser do
  @moduledoc """
  Documentation for SalesForceMarketingCloudCsvParser.
  """

  NimbleCSV.define(Parser, separator: ",", escape: "\"")
end
