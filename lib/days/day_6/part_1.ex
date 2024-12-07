defmodule AdventOfCode2024.Day6.Part1 do
  @moduledoc """
  --- Day 6: Guard Patrol ---
  The map shows the current position of the guard with ^ (to indicate the guard is currently facing up from the perspective of the map). Any obstructions - crates, desks, alchemical reactors, etc. - are shown as #.

  Lab guards in 1518 follow a very strict patrol protocol which involves repeatedly following these steps:

  If there is something directly in front of you, turn right 90 degrees.
  Otherwise, take a step forward.
  Following the above protocol, the guard moves up several times until she reaches an obstacle (in this case, a pile of failed suit prototypes):

  ....#.....
  ....^....#
  ..........
  ..#.......
  .......#..
  ..........
  .#........
  ........#.
  #.........
  ......#...
  Because there is now an obstacle in front of the guard, she turns right before continuing straight in her new facing direction:

  ....#.....
  ........>#
  ..........
  ..#.......
  .......#..
  ..........
  .#........
  ........#.
  #.........
  ......#...
  Reaching another obstacle (a spool of several very long polymers), she turns right again and continues downward:

  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#......v.
  ........#.
  #.........
  ......#...
  This process continues for a while, but the guard eventually leaves the mapped area (after walking past a tank of universal solvent):

  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#........
  ........#.
  #.........
  ......#v..
  By predicting the guard's route, you can determine which specific positions in the lab will be in the patrol path. Including the guard's starting position, the positions visited by the guard before leaving the area are marked with an X:

  ....#.....
  ....XXXXX#
  ....X...X.
  ..#.X...X.
  ..XXXXX#X.
  ..X.X.X.X.
  .#XXXXXXX.
  .XXXXXXX#.
  #XXXXXXX..
  ......#X..
  In this example, the guard will visit 41 distinct positions on your map.

  Predict the path of the guard. How many distinct positions will the guard visit before leaving the mapped area?
  """

  @behaviour AdventOfCode2024.Puzzle

  alias AdventOfCode2024.Day6

  @doc """
  Parse the input string into a grid of characters.
  """
  def parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  @doc """
  Find the guard's starting position in the map.
  Returns a tuple of {row, col}.
  """
  def find_guard_position(map) do
    map
    |> Enum.with_index()
    |> Enum.find_value(fn {row, row_idx} ->
      case Enum.find_index(row, &(&1 in ["^", ">", "v", "<"])) do
        nil -> nil
        col_idx -> {row_idx, col_idx}
      end
    end)
  end

  @doc """
  Get the guard's initial direction from their starting position.
  """
  def get_initial_direction(map, pos), do: get_pos(map, pos)

  @doc """
  Process the guard's movement and return the count of unique positions visited.
  """
  def count_visited_positions(grid, start_pos, start_dir) do
    MapSet.new()
    |> simulate_guard_path(grid, start_pos, start_dir)
    |> MapSet.size()
  end

  @doc """
  Calculate the next position based on current position and direction.
  """
  def calculate_next_position({row, col}, dir) do
    case dir do
      "^" -> {row - 1, col}
      ">" -> {row, col + 1}
      "v" -> {row + 1, col}
      "<" -> {row, col - 1}
    end
  end

  @doc """
  Check if a position is within the map boundaries.
  """
  def position_in_bounds?(map, {row, col}) do
    row >= 0 and col >= 0 and row < length(map) and col < length(Enum.at(map, 0))
  end

  @doc """
  Check if a position is blocked by an obstruction. Obstruction == `#`
  """
  def position_blocked?(map, pos), do: get_pos(map, pos) == "#"

  @doc """
  Get the value at a position in the map.
  Returns nil if position is out of bounds.
  """
  def get_pos(map, {row, col}) do
    if position_in_bounds?(map, {row, col}) do
      map |> Enum.at(row) |> Enum.at(col)
    end
  end

  @doc """
  Turn the guard's direction 90 degrees to the right.
  """
  def turn_right(dir) do
    case dir do
      "^" -> ">"
      ">" -> "v"
      "v" -> "<"
      "<" -> "^"
    end
  end

  defp simulate_guard_path(visited, map, pos, dir) do
    visited = MapSet.put(visited, pos)
    next_pos = calculate_next_position(pos, dir)

    cond do
      not position_in_bounds?(map, next_pos) -> visited
      position_blocked?(map, next_pos) -> simulate_guard_path(visited, map, pos, turn_right(dir))
      true -> simulate_guard_path(visited, map, next_pos, dir)
    end
  end

  def solve() do
    map =
      Day6.input_file()
      |> parse_input()

    start_pos = find_guard_position(map)
    start_dir = get_initial_direction(map, start_pos)
    count_visited_positions(map, start_pos, start_dir)
  end
end
