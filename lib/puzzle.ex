defmodule AdventOfCode2024.Puzzle do
  @moduledoc """
  A behaviour that ensures all puzzle modules implement a solve/0 function.
  """
  @callback solve() :: any()

  def solve(module) do
    module.solve()
  end
end
