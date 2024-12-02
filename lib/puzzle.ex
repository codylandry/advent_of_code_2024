defmodule AdventOfCode2024.Puzzle do
  @moduledoc """
  A behaviour that ensures all puzzle modules implement a solve/0 function.
  """
  @callback solve() :: any()

  def solve(module) do
    module.solve()
  end

  @doc """
  Returns a list of all modules that implement the Puzzle behaviour.
  """
  def all do
    app = Mix.Project.config()[:app]

    :application.get_key(app, :modules)
    |> elem(1)
    |> Enum.filter(fn module ->
      implements_behaviour?(module, __MODULE__)
    end)
    |> Enum.sort()
  end

  defp implements_behaviour?(module, behaviour) do
    module.module_info(:attributes)
    |> Keyword.get_values(:behaviour)
    |> List.flatten()
    |> Enum.member?(behaviour)
  rescue
    _ -> false
  end
end
