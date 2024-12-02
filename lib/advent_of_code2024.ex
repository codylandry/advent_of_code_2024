defmodule AdventOfCode2024 do
  alias AdventOfCode2024.{Day1}

  @puzzles [
    Day1.Part1,
    Day1.Part2
  ]

  def priv_dir, do: :code.priv_dir(:advent_of_code_2024)

  def read_priv_file(file) do
    priv_dir()
    |> Path.join(file)
    |> File.read!()
  end

  def run_all do
    tasks =
      @puzzles
      |> Enum.map(fn puzzle ->
        Task.async(fn ->
          {puzzle, puzzle.solve()}
        end)
      end)

    results =
      tasks
      |> Task.await_many(:infinity)
      |> Enum.map(fn {puzzle, result} -> "#{puzzle.label()}: #{result}" end)
      |> Enum.join("\n")

    IO.puts("\nPuzzle Results:\n#{results}\n")
  end

  def run(day, part) do
    module = Module.concat([AdventOfCode2024, "Day#{day}", "Part#{part}"])
    label = apply(module, :label, [])
    result = apply(module, :solve, [])

    IO.puts("#{label}: #{result}")
  end
end
