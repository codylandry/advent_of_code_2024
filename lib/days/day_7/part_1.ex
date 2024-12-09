defmodule AdventOfCode2024.Day7.Part1 do
  @moduledoc """
  Only three of the above equations can be made true by inserting operators:

  190: 10 19 has only one position that accepts an operator: between 10 and 19. Choosing + would give 29, but choosing * would give the test value (10 * 19 = 190).
  3267: 81 40 27 has two positions for operators. Of the four possible configurations of the operators, two cause the right side to match the test value: 81 + 40 * 27 and 81 * 40 + 27 both equal 3267 (when evaluated left-to-right)!
  292: 11 6 16 20 can be solved in exactly one way: 11 + 6 * 16 + 20.
  The engineers just need the total calibration result, which is the sum of the test values from just the equations that could possibly be true. In the above example, the sum of the test values for the three equations listed above is 3749.

  Determine which equations could possibly be true. What is their total calibration result?
  """
  @behaviour AdventOfCode2024.Puzzle

  alias AdventOfCode2024.Day7

  @operators ["+", "*"]

  @doc """
  Parses the input file into a list of tuples containing {test_value, values}.
  Example: {190, ["10", "19"]}
  """
  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split(&1, ": "))
    |> Enum.map(fn [test_value, values] ->
      {String.to_integer(test_value), String.split(values, " ")}
    end)
  end

  @doc """
  Generates all possible permutations of operators for a given list size.
  For example, with operators ["+", "*"] and size 2:
  Returns: [["+", "+"], ["+", "*"], ["*", "+"], ["*", "*"]]
  """
  def permutations(list, size) do
    list
    |> List.duplicate(size)
    |> Enum.reduce([[]], fn elements, acc ->
      for element <- elements,
          list <- acc,
          do: list ++ [element]
    end)
  end

  @doc """
  Takes a list of values and generates all possible expressions by inserting operators.
  Example: For values ["1", "2", "3"], generates expressions like:
  "1 + 2 + 3", "1 + 2 * 3", "1 * 2 + 3", "1 * 2 * 3"
  """
  def get_possible_expressions(values, operators \\ @operators) do
    for permutation <- permutations(operators, length(values) - 1) do
      (permutation ++ [""])
      |> Enum.zip(values)
      |> Enum.map(fn {operator, value} ->
        "#{value} #{operator}"
      end)
      |> Enum.join(" ")
      |> String.trim()
    end
  end

  # Helper functions to evaluate expressions parts with different operators
  def evaluate_expression_part(acc, {"||", value}), do: String.to_integer("#{acc}#{value}")
  def evaluate_expression_part(acc, {"+", value}), do: acc + value
  def evaluate_expression_part(acc, {"*", value}), do: acc * value

  @doc """
  Evaluates a mathematical expression string from left to right.
  Example: "1 + 2 * 3" evaluates to 9 (as opposed to 7 with sequence of operations)
  """
  def evaluate_expression(expression) do
    parts =
      expression
      |> String.split(" ")

    [first_number_str | rest] = parts
    first_number = String.to_integer(first_number_str)

    rest
    |> Enum.chunk_every(2)
    |> Enum.reduce(first_number, fn [operator, value], acc ->
      evaluate_expression_part(acc, {operator, String.to_integer(value)})
    end)
  end

  @doc """
  Checks if any possible combination of operators between the values can produce
  the test value when evaluated left-to-right.
  """
  def has_successful_expression?(test_value, values, operators \\ @operators) do
    get_possible_expressions(values, operators)
    |> Enum.any?(fn expression ->
      evaluate_expression(expression) == test_value
    end)
  end

  def solve() do
    Day7.input_file()
    |> parse_input()
    |> Enum.filter(fn {test_value, values} ->
      has_successful_expression?(test_value, values)
    end)
    |> Enum.map(fn {test_value, _} -> test_value end)
    |> Enum.sum()
  end
end
