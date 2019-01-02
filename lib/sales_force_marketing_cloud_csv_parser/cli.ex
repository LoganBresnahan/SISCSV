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
      File.stream!(file, read_ahead: 3_000_000)
      |> Parser.parse_stream()
      |> Flow.from_enumerable()
      |> Flow.map(fn([a1, a2, a3, a4, b1, b2, b3, b4, b5, b6, a5]) ->
        bits =
          [b1, b2, b3, b4, b5, b6]
          |> Enum.map(fn(bit) ->
            case String.downcase(bit) do
              "true" -> "1"
              "false" -> "0"
              _ -> bit
            end
          end)

        [a1, a2, a3, a4] ++ bits ++ [a5]
      end)
      |> Parser.dump_to_iodata()

      File.write!("copy_#{file}", io_data)
  end
end
