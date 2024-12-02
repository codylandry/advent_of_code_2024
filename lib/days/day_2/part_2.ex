defmodule AdventOfCode2024.Day2.Part2 do
  @moduledoc """
  --- Part Two ---
  The engineers are surprised by the low number of safe reports until they realize they forgot to tell you about the Problem Dampener.

  The Problem Dampener is a reactor-mounted module that lets the reactor safety systems tolerate a single bad level in what would otherwise be a safe report. It's like the bad level never happened!

  Now, the same rules apply as before, except if removing a single level from an unsafe report would make it safe, the report instead counts as safe.

  More of the above example's reports are now safe:

  7 6 4 2 1: Safe without removing any level.
  1 2 7 8 9: Unsafe regardless of which level is removed.
  9 7 6 2 1: Unsafe regardless of which level is removed.
  1 3 2 4 5: Safe by removing the second level, 3.
  8 6 4 4 1: Safe by removing the third level, 4.
  1 3 6 7 9: Safe without removing any level.
  Thanks to the Problem Dampener, 4 reports are actually safe!

  Update your analysis by handling situations where the Problem Dampener can remove a single level from unsafe reports. How many reports are now safe?
  """

  @behaviour AdventOfCode2024.Puzzle

  alias AdventOfCode2024.Day2

  @doc """
  Check if a report is safe, meaning it is consistent and the levels are within the range of 1 to 3 of each other.

  The report is also said to be safe if removing a single level from it makes it safe.
  """
  def level_is_safe?(report) do
    # First check if the report is already valid
    if Day2.Part1.is_report_safe?(report) do
      true
    else
      # Try removing each position one at a time and check if any resulting sequence is valid
      0..(length(report) - 1)
      |> Enum.any?(fn idx ->
        {left, [_removed | right]} = Enum.split(report, idx)

        # using the safe check from part 1
        Day2.Part1.is_report_safe?(left ++ right)
      end)
    end
  end

  @doc """
  Apply the problem dampener to a list of reports.
  """
  def apply_problem_dampener(reports) do
    reports
    |> Enum.filter(&level_is_safe?/1)
    |> length()
  end

  def solve do
    Day2.input_file()
    |> Day2.Part1.parse_input()
    |> apply_problem_dampener()
  end
end
