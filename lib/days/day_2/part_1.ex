defmodule AdventOfCode2024.Day2.Part1 do
  @moduledoc """
  The engineers are trying to figure out which reports are safe. The Red-Nosed reactor safety systems can only tolerate levels that are either gradually increasing or gradually decreasing. So, a report only counts as safe if both of the following are true:

  The levels are either all increasing or all decreasing.
  Any two adjacent levels differ by at least one and at most three.
  In the example above, the reports can be found safe or unsafe by checking those rules:

  7 6 4 2 1: Safe because the levels are all decreasing by 1 or 2.
  1 2 7 8 9: Unsafe because 2 7 is an increase of 5.
  9 7 6 2 1: Unsafe because 6 2 is a decrease of 4.
  1 3 2 4 5: Unsafe because 1 3 is increasing but 3 2 is decreasing.
  8 6 4 4 1: Unsafe because 4 4 is neither an increase or a decrease.
  1 3 6 7 9: Safe because the levels are all increasing by 1, 2, or 3.
  So, in this example, 2 reports are safe.

  Analyze the unusual data from the engineers. How many reports are safe?
  """

  @behaviour AdventOfCode2024.Puzzle

  alias AdventOfCode2024.Day2

  @doc """
  Parse the input into a list of lists of integers, where each list represents a report.
  """
  def parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split()
      |> Enum.map(&String.to_integer/1)
    end)
  end

  @doc """
  Check if the levels in a report are consistent, meaning they are either all increasing or all decreasing.
  """
  def is_report_consistent?(levels) do
    # if the first level is less than the second, then the report is increasing
    is_increasing = Enum.at(levels, 0) <= Enum.at(levels, 1)

    if is_increasing do
      Enum.sort(levels) == levels
    else
      Enum.sort(levels, :desc) == levels
    end
  end

  @doc """
  Check if the levels in a report are within the range of 1 to 3 of each other.
  """
  def are_levels_within_range?(levels) do
    levels
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [a, b] -> abs(a - b) in 1..3 end)
  end

  @doc """
  Check if a report is safe, meaning it is consistent and the levels are within the range of 1 to 3 of each other.
  """
  def is_report_safe?(levels) do
    is_report_consistent?(levels) and are_levels_within_range?(levels)
  end

  @doc """
  Get the number of safe reports from a list of reports.
  """
  def get_num_safe_reports(reports) do
    reports
    |> Enum.count(&is_report_safe?/1)
  end

  def solve do
    Day2.input_file()
    |> parse_input()
    |> get_num_safe_reports()
  end
end
