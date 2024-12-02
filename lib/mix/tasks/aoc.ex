defmodule Mix.Tasks.Aoc do
  use Mix.Task

  @shortdoc "Runs Advent of Code solutions"
  def run(_) do
    AdventOfCode2024.run_all()
  end
end
