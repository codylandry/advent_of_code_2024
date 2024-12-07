defmodule AdventOfCode2024.Day6.Part2 do
  @moduledoc """
  --- Part Two ---
  While The Historians begin working around the guard's patrol route, you borrow their fancy device and step outside the lab. From the safety of a supply closet, you time travel through the last few months and record the nightly status of the lab's guard post on the walls of the closet.

  Returning after what seems like only a few seconds to The Historians, they explain that the guard's patrol area is simply too large for them to safely search the lab without getting caught.

  Fortunately, they are pretty sure that adding a single new obstruction won't cause a time paradox. They'd like to place the new obstruction in such a way that the guard will get stuck in a loop, making the rest of the lab safe to search.

  To have the lowest chance of creating a time paradox, The Historians would like to know all of the possible positions for such an obstruction. The new obstruction can't be placed at the guard's starting position - the guard is there right now and would notice.

  In the above example, there are only 6 different positions where a new obstruction would cause the guard to get stuck in a loop. The diagrams of these six situations use O to mark the new obstruction, | to show a position where the guard moves up/down, - to show a position where the guard moves left/right, and + to show a position where the guard moves both up/down and left/right.

  Option one, put a printing press next to the guard's starting position:

  ....#.....
  ....+---+#
  ....|...|.
  ..#.|...|.
  ....|..#|.
  ....|...|.
  .#.O^---+.
  ........#.
  #.........
  ......#...
  Option two, put a stack of failed suit prototypes in the bottom right quadrant of the mapped area:


  ....#.....
  ....+---+#
  ....|...|.
  ..#.|...|.
  ..+-+-+#|.
  ..|.|.|.|.
  .#+-^-+-+.
  ......O.#.
  #.........
  ......#...
  Option three, put a crate of chimney-squeeze prototype fabric next to the standing desk in the bottom right quadrant:

  ....#.....
  ....+---+#
  ....|...|.
  ..#.|...|.
  ..+-+-+#|.
  ..|.|.|.|.
  .#+-^-+-+.
  .+----+O#.
  #+----+...
  ......#...
  Option four, put an alchemical retroencabulator near the bottom left corner:

  ....#.....
  ....+---+#
  ....|...|.
  ..#.|...|.
  ..+-+-+#|.
  ..|.|.|.|.
  .#+-^-+-+.
  ..|...|.#.
  #O+---+...
  ......#...
  Option five, put the alchemical retroencabulator a bit to the right instead:

  ....#.....
  ....+---+#
  ....|...|.
  ..#.|...|.
  ..+-+-+#|.
  ..|.|.|.|.
  .#+-^-+-+.
  ....|.|.#.
  #..O+-+...
  ......#...
  Option six, put a tank of sovereign glue right next to the tank of universal solvent:

  ....#.....
  ....+---+#
  ....|...|.
  ..#.|...|.
  ..+-+-+#|.
  ..|.|.|.|.
  .#+-^-+-+.
  .+----++#.
  #+----++..
  ......#O..
  It doesn't really matter what you choose to use as an obstacle so long as you and The Historians can put it into position without the guard noticing. The important thing is having enough options that you can find one that minimizes time paradoxes, and in this example, there are 6 different positions you could choose.

  You need to get the guard stuck in a loop by adding a single new obstruction. How many different positions could you choose for this obstruction?
  """

  @behaviour AdventOfCode2024.Puzzle

  alias AdventOfCode2024.Day6

  @doc """
  Parses the input string into a grid of characters.
  """
  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
  end

  @doc """
  Finds the guard's starting position in the map.
  Returns a tuple of {row_index, column_index}.
  """
  def find_guard_start(map) do
    {row, row_idx} =
      map
      |> Enum.with_index()
      |> Enum.find(fn {row, _idx} -> "^" in row end)

    col_idx = Enum.find_index(row, fn char -> char == "^" end)

    {row_idx, col_idx}
  end

  @doc """
  Rotates the guard's direction 90 degrees clockwise.
  """
  def rotate_clockwise(direction) do
    case direction do
      "^" -> ">"
      ">" -> "v"
      "v" -> "<"
      "<" -> "^"
    end
  end

  @doc """
  Calculates the next position based on current position and direction.
  """
  def next_position({row, col}, direction) do
    case direction do
      "^" -> {row - 1, col}
      ">" -> {row, col + 1}
      "v" -> {row + 1, col}
      "<" -> {row, col - 1}
    end
  end

  @doc """
  Checks if a position is within the map boundaries.
  """
  def valid_position?(map, {row, col}) do
    row >= 0 and col >= 0 and row < length(map) and col < length(Enum.at(map, row))
  end

  @doc """
  Gets the character at a position in the map.
  Returns nil if position is out of bounds.
  """
  def get_at_position(map, {row, col}) do
    if valid_position?(map, {row, col}) do
      Enum.at(Enum.at(map, row), col)
    end
  end

  @doc """
  Simulates the guard's movement from a position and direction.
  Returns {:loop, visited} if a loop is detected, {:stop, visited} otherwise.
  """
  def simulate_guard_path(map, position, direction, visited) do
    if MapSet.member?(visited, {position, direction}) do
      {:loop, visited}
    else
      visited = MapSet.put(visited, {position, direction})
      next_pos = next_position(position, direction)

      cond do
        not valid_position?(map, next_pos) ->
          {:stop, visited}

        get_at_position(map, next_pos) == "#" ->
          new_direction = rotate_clockwise(direction)
          simulate_guard_path(map, position, new_direction, visited)

        true ->
          simulate_guard_path(map, next_pos, direction, visited)
      end
    end
  end

  @doc """
  Tests if placing an obstruction at a position causes the guard to get stuck in a loop.
  """
  def creates_loop?(map, obstruction_pos) do
    # Place the obstruction
    updated_map =
      List.update_at(map, obstruction_pos |> elem(0), fn row ->
        List.replace_at(row, obstruction_pos |> elem(1), "#")
      end)

    guard_start = find_guard_start(updated_map)
    initial_direction = "^"
    visited = MapSet.new()

    case simulate_guard_path(updated_map, guard_start, initial_direction, visited) do
      {:loop, _} -> true
      _ -> false
    end
  end

  @doc """
  Finds all valid positions where placing an obstruction would cause a loop.
  """
  def find_loop_positions(map) do
    guard_start = find_guard_start(map)

    for row <- 0..(length(map) - 1),
        col <- 0..(length(Enum.at(map, row)) - 1),
        get_at_position(map, {row, col}) != "#",
        {row, col} != guard_start,
        creates_loop?(map, {row, col}),
        do: {row, col}
  end

  def solve(input \\ nil) do
    map =
      case input do
        nil -> Day6.input_file() |> parse_input()
        input -> parse_input(input)
      end

    map
    |> find_loop_positions()
    |> length()
  end
end
