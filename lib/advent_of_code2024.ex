defmodule AdventOfCode2024 do
  alias AdventOfCode2024.Puzzle

  def priv_dir, do: :code.priv_dir(:advent_of_code_2024)

  def read_priv_file(file) do
    priv_dir()
    |> Path.join(file)
    |> File.read!()
  end

  def run_all do
    tasks =
      Puzzle.all()
      |> Enum.map(fn puzzle ->
        Task.async(fn ->
          {puzzle, Puzzle.solve(puzzle)}
        end)
      end)

    results =
      tasks
      |> Task.await_many(:infinity)
      |> Enum.map(fn {puzzle, result} -> "#{puzzle}: #{result}" end)
      |> Enum.join("\n")

    IO.puts("\nPuzzle Results:\n#{results}\n")
  end

  def run(day, part) do
    module = Module.concat([AdventOfCode2024, "Day#{day}", "Part#{part}"])
    result = Puzzle.solve(module)

    IO.puts("#{module}: #{result}")
  end
end
