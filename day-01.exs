# Run as: iex --dot-iex path/to/notebook.exs

# Title: AOC 2023 Day 01

Mix.install([
  {:kino_aoc, "~> 0.1"}
])

# ── Day 01 ──

{:ok, puzzle_input} =
  KinoAOC.download_puzzle("2023", "1", System.fetch_env!("LB_THEAVEASSO"))

defmodule Helpers do
  @digit_mapping %{
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
  }

  def convert_word_to_digit(word) do
    case Map.get(@digit_mapping, String.downcase(word)) do
      # If not found in the mapping, return the original word
      nil -> word
      digit -> digit
    end
  end

  def patterns(),
    do: [
      "one",
      "two",
      "three",
      "four",
      "five",
      "six",
      "seven",
      "eight",
      "nine",
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9"
    ]
end

# ── Part 01 ──

puzzle_input
|> String.split("\n", trim: true)
|> Enum.map(&String.replace(&1, ~r/[^0-9]/, ""))
|> Enum.map(&((String.at(&1, 0) <> String.at(&1, -1)) |> String.to_integer()))
|> Enum.sum()

# ── Part 02 ──

puzzle_input
|> String.split("\n", trim: true)
|> Enum.map(&Regex.scan(~r/(?=(#{Enum.join(Helpers.patterns(), "|")}))/, &1))
|> Enum.map(fn list ->
  list
  |> Enum.map(fn [_, val] -> Helpers.convert_word_to_digit(val) end)
  |> (fn list -> [Enum.at(list, 0), Enum.at(list, -1)] end).()
  |> Enum.join("")
  |> String.to_integer()
end)
|> Enum.sum()
