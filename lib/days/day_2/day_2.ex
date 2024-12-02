defmodule AdventOfCode2024.Day2 do
  @moduledoc """
  --- Day 2: Red-Nosed Reports ---
  Fortunately, the first location The Historians want to search isn't a long walk from the Chief Historian's office.

  While the Red-Nosed Reindeer nuclear fusion/fission plant appears to contain no sign of the Chief Historian, the engineers there run up to you as soon as they see you. Apparently, they still talk about the time Rudolph was saved through molecular synthesis from a single electron.

  They're quick to add that - since you're already here - they'd really appreciate your help analyzing some unusual data from the Red-Nosed reactor. You turn to check if The Historians are waiting for you, but they seem to have already divided into groups that are currently searching every corner of the facility. You offer to help with the unusual data.

  The unusual data (your puzzle input) consists of many reports, one report per line. Each report is a list of numbers called levels that are separated by spaces. For example:

  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
  This example data contains six reports each containing five levels.
  """

  @input_file "inputs/day2.txt"

  def input_file, do: AdventOfCode2024.read_priv_file(@input_file)
end
