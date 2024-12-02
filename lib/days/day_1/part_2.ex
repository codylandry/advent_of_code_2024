defmodule AdventOfCode2024.Day1.Part2 do
  @behaviour AdventOfCode2024.Puzzle
  @moduledoc """
  --- Part Two ---
  Your analysis only confirmed what everyone feared: the two lists of location IDs are indeed very different.

  Or are they?

  The Historians can't agree on which group made the mistakes or how to read most of the Chief's handwriting, but in the commotion you notice an interesting detail: a lot of location IDs appear in both lists! Maybe the other numbers aren't location IDs at all but rather misinterpreted handwriting.

  This time, you'll need to figure out exactly how often each number from the left list appears in the right list. Calculate a total similarity score by adding up each number in the left list after multiplying it by the number of times that number appears in the right list.

  Here are the same example lists again:

  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  For these example lists, here is the process of finding the similarity score:

  The first number in the left list is 3. It appears in the right list three times, so the similarity score increases by 3 * 3 = 9.
  The second number in the left list is 4. It appears in the right list once, so the similarity score increases by 4 * 1 = 4.
  The third number in the left list is 2. It does not appear in the right list, so the similarity score does not increase (2 * 0 = 0).
  The fourth number, 1, also does not appear in the right list.
  The fifth number, 3, appears in the right list three times; the similarity score increases by 9.
  The last number, 3, appears in the right list three times; the similarity score again increases by 9.
  So, for these example lists, the similarity score at the end of this process is 31 (9 + 4 + 0 + 0 + 9 + 9).
  """

  alias AdventOfCode2024.Day1

  @doc """
  Parses the input into a list of two lists, where the first list is the left column and the second list is the right column.
  """
  def parse_input(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(&Enum.map(&1, fn i -> String.to_integer(i) end))
    |> Enum.zip()
    |> Enum.map(fn tuple -> Tuple.to_list(tuple) end)
  end

  @doc """
  Returns a list of tuples where each tuple contains a number from the left list and the count of how many times it appears in the right list.
  """
  def find_similar_numbers([list1, list2]) do
    list1
    |> Enum.map(fn number -> {number, Enum.count(list2, fn i -> i == number end)} end)
  end

  @doc """
  Calculates the similarity score by summing the product of each number and its count in the right list.
  """
  def calculate_similarity_score(similar_numbers) do
    similar_numbers
    |> Enum.map(fn {number, count} -> number * count end)
    |> Enum.sum()
  end

  @doc """
  Solves the puzzle by parsing the input, finding the similar numbers, and calculating the similarity score.
  """
  def solve() do
    Day1.input_file()
    |> parse_input()
    |> find_similar_numbers()
    |> calculate_similarity_score()
  end
end
