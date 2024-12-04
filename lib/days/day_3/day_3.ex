defmodule AdventOfCode2024.Day3 do
  @moduledoc """
  --- Day 3: Mull It Over ---
  Our computers are having issues, so I have no idea if we have any Chief Historians in stock! You're welcome to check the warehouse, though," says the mildly flustered shopkeeper at the North Pole Toboggan Rental Shop. The Historians head out to take a look.

  The shopkeeper turns to you. "Any chance you can see why our computers are having issues again?"
  """

  @input_file "inputs/day3.txt"

  def input_file, do: AdventOfCode2024.read_priv_file(@input_file)

  @mul_regex ~r/mul\((\d{1,3}),(\d{1,3})\)/

  @doc """
  Get all mul instructions from the input.
  """
  def get_mul_instructions(input), do: Regex.scan(@mul_regex, input)

  @doc """
  Get the product of a mul instruction by multiplying the two numbers in the match ie mul(X,Y) -> X * Y
  """
  def get_mul_instruction_product([_match, x, y]), do: String.to_integer(x) * String.to_integer(y)
end
