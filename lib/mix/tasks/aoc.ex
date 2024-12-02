defmodule Mix.Tasks.Aoc do
  use Mix.Task

  @shortdoc "Runs Advent of Code solutions"
  def run(args) do
    case args do
      [] ->
        AdventOfCode2024.run_all()

      [day, part] ->
        AdventOfCode2024.run(day, part)

      _ ->
        Mix.raise("Invalid arguments. Usage: mix aoc [Day1 Part1]")
    end
  end
end
