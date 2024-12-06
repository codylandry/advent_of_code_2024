defmodule AdventOfCode2024.Day4.Part1 do
  @moduledoc """
  This word search allows words to be horizontal, vertical, diagonal, written backwards, or even overlapping other words. It's a little unusual, though, as you don't merely need to find one instance of XMAS - you need to find all of them. Here are a few ways XMAS might appear, where irrelevant characters have been replaced with .:

  ..X...
  .SAMX.
  .A..A.
  XMAS.S
  .X....
  The actual word search will be full of letters instead. For example:

  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  In this word search, XMAS occurs a total of 18 times; here's the same word search again, but where letters not involved in any XMAS have been replaced with .:

  ....XXMAS.
  .SAMXMS...
  ...S..A...
  ..A.A.MS.X
  XMASAMX.MM
  X.....XA.A
  S.S.S.S.SS
  .A.A.A.A.A
  ..M.M.M.MM
  .X.X.XMASX
  Take a look at the little Elf's word search. How many times does XMAS appear?
  """

  @behaviour AdventOfCode2024.Puzzle

  alias AdventOfCode2024.Day4

  # All possible directions to check: right, down-right, down, down-left, left, up-left, up, up-right
  @directions [
    # right
    {0, 1},
    # down-right
    {1, 1},
    # down
    {1, 0},
    # down-left
    {1, -1},
    # left
    {0, -1},
    # up-left
    {-1, -1},
    # up
    {-1, 0},
    # up-right
    {-1, 1}
  ]

  def at_coordinates(input, row, col), do: Enum.at(Enum.at(input, row), col)

  def get_grid_dimensions(input) do
    rows = length(input)
    cols = length(Enum.at(input, 0))

    {rows, cols}
  end

  def get_x_positions(input) do
    {rows, cols} = get_grid_dimensions(input)

    for row <- 0..(rows - 1),
        col <- 0..(cols - 1),
        at_coordinates(input, row, col) == "X",
        do: {row, col}
  end

  def check_xmas_in_all_directions(input, row, col) do
    {rows, cols} = get_grid_dimensions(input)

    @directions
    |> Enum.filter(fn {dy, dx} ->
      check_xmas_in_direction(input, row, col, dy, dx, rows, cols)
    end)
  end

  # Helper function to check if "XMAS" exists in a given direction from a starting point
  defp check_xmas_in_direction(grid, row, col, dy, dx, max_rows, max_cols) do
    pattern = ["X", "M", "A", "S"]

    Enum.reduce_while(Enum.with_index(pattern), true, fn {char, i}, _acc ->
      new_row = row + dy * i
      new_col = col + dx * i

      cond do
        new_row < 0 or new_row >= max_rows -> {:halt, false}
        new_col < 0 or new_col >= max_cols -> {:halt, false}
        at_coordinates(grid, new_row, new_col) != char -> {:halt, false}
        true -> {:cont, true}
      end
    end)
  end

  def solve do
    input =
      Day4.input_file()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    # For each X position, check all directions for "XMAS"
    get_x_positions(input)
    |> Enum.map(fn {row, col} ->
      check_xmas_in_all_directions(input, row, col)
    end)
    |> Enum.map(&length/1)  # Count the number of valid directions for each X
    |> Enum.sum()           # Sum up all the XMAS patterns found
  end
end
