defmodule AdventOfCode2024.Day4.Part2 do
  @moduledoc """
  --- Part Two ---
  The Elf looks quizzically at you. Did you misunderstand the assignment?

  Looking for the instructions, you flip over the word search to find that this isn't actually an XMAS puzzle; it's an X-MAS puzzle in which you're supposed to find two MAS in the shape of an X. One way to achieve that is like this:

  M.S
  .A.
  M.S
  Irrelevant characters have again been replaced with . in the above diagram. Within the X, each MAS can be written forwards or backwards.

  Here's the same example from before, but this time all of the X-MASes have been kept instead:

  .M.S......
  ..A..MSMS.
  .M.S.MAA..
  ..A.ASMSM.
  .M.S.M....
  ..........
  S.S.S.S.S.
  .A.A.A.A..
  M.M.M.M.M.
  ..........
  In this example, an X-MAS appears 9 times.

  Flip the word search from the instructions back over to the word search side and try again. How many times does an X-MAS appear?
  """

  @behaviour AdventOfCode2024.Puzzle

  alias AdventOfCode2024.Day4

  def at_coordinates(input, row, col) when row >= 0 and col >= 0 do
    case Enum.at(input, row) do
      nil -> nil
      row_data -> Enum.at(row_data, col)
    end
  end

  def get_grid_dimensions(input) do
    rows = length(input)
    cols = length(Enum.at(input, 0))
    {rows, cols}
  end

  def check_mas_sequence([m, a, s]) do
    (m <> a <> s) in ["MAS", "SAM"]
  end

  def check_mas_sequence(_), do: false

  def check_x_pattern(grid, center_row, center_col) do
    # Check upper-left to lower-right diagonal
    ul_lr = [
      at_coordinates(grid, center_row - 1, center_col - 1),
      at_coordinates(grid, center_row, center_col),
      at_coordinates(grid, center_row + 1, center_col + 1)
    ]

    # Check upper-right to lower-left diagonal
    ur_ll = [
      at_coordinates(grid, center_row - 1, center_col + 1),
      at_coordinates(grid, center_row, center_col),
      at_coordinates(grid, center_row + 1, center_col - 1)
    ]

    check_mas_sequence(ul_lr) && check_mas_sequence(ur_ll)
  end

  def solve do
    input =
      Day4.input_file()
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)

    {rows, cols} = get_grid_dimensions(input)

    # For each possible center point of an X pattern
    count =
      for row <- 1..(rows - 2),
          col <- 1..(cols - 2),
          at_coordinates(input, row, col) == "A",
          check_x_pattern(input, row, col),
          do: 1

    Enum.sum(count)
  end
end
