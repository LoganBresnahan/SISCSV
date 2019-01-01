defmodule SalesForceMarketingCloudCsvParser.Cli do
  @moduledoc """
  CLI for taking in CSV files and changing String TRUE and FALSE
  to string 1 and 0.
  """

  @csv_file_match ~r{^.*\.csv$}

  def main(args \\ []) do
    run(args)
  end

  defp run([]), do: IO.puts "Operation Finished"

  defp run([head | tail]) do
    match_csv?(head)
    |> manipulate(head)

    run(tail)
  end

  defp match_csv?(input) do
    Regex.match?(@csv_file_match, input)
  end

  defp manipulate(false, _file) do
    IO.puts "not a csv"
  end

  defp manipulate(true, file) do
    io_data =
      File.read!(file)
      |> Parser.parse_string(headers: false)
      |> row_results([], 0)
      |> Parser.dump_to_iodata()

    File.write!("copy_#{file}", io_data)
  end

  def row_results([headers_row | tail], acc, count) do
    row_results(tail, acc, count, headers_row)
  end

  def row_results([], acc, _count, headers_row), do: [headers_row] ++ acc

  def row_results([head | tail], acc, count, headers_row) do
    IO.puts count

    [a1, a2, a3, a4, b1, b2, b3, b4, b5, b6, a5] = head

    bits = bit_results([b1, b2, b3, b4, b5, b6], [])

    row_result = [a1, a2, a3, a4] ++ bits ++ [a5]

    row_results(tail, [row_result] ++ acc, count + 1, headers_row)
  end

  def bit_results([], acc), do: acc

  def bit_results([bit |tail], acc) do
    bit =
      case String.downcase(bit) do
        "true" -> "1"
        "false" -> "0"
        _ -> bit
      end

    bit_results(tail, [bit] ++ acc)
  end
end
