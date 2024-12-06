defmodule AdventOfCode2024.Day5.Part2 do
  @moduledoc """
  --- Part Two ---
  While the Elves get to work printing the correctly-ordered updates, you have a little time to fix the rest of them.

  For each of the incorrectly-ordered updates, use the page ordering rules to put the page numbers in the right order. For the above example, here are the three incorrectly-ordered updates and their correct orderings:

  75,97,47,61,53 becomes 97,75,47,61,53.
  61,13,29 becomes 61,29,13.
  97,13,75,29,47 becomes 97,75,47,29,13.
  After taking only the incorrectly-ordered updates and ordering them correctly, their middle page numbers are 47, 29, and 47. Adding these together produces 123.

  Find the updates which are not in the correct order. What do you get if you add up the middle page numbers after correctly ordering just those updates?
  """

  @behaviour AdventOfCode2024.Puzzle

  alias AdventOfCode2024.Day5

  @doc """
  Build a rules lookup map where each page maps to list of pages that must come after it.
  """
  def rules_map(parsed_rules) do
    parsed_rules
    |> Enum.group_by(fn {left, _} -> left end)
    |> Enum.map(fn {left, rules} -> {left, Enum.map(rules, fn {_, right} -> right end)} end)
    |> Map.new()
  end

  def fix_update(update, parsed_rules) do
    # Build a rules lookup map where each page maps to list of pages that must come after it
    rules_map = rules_map(parsed_rules)
    pages = Day5.Part1.parse_update(update)

    # Sort using custom comparator that checks rules
    Enum.sort(pages, fn page_a, page_b ->
      must_follow_a = Map.get(rules_map, page_a, [])
      must_follow_b = Map.get(rules_map, page_b, [])

      cond do
        # A must come before B
        page_b in must_follow_a -> true
        # B must come before A
        page_a in must_follow_b -> false
        # Keep original order if no rule exists
        true -> false
      end
    end)
  end

  def solve do
    {parsed_rules, updates} = Day5.Part1.parse_input(Day5.input_file())

    updates
    |> Enum.filter(fn update ->
      update
      |> Day5.Part1.index_update()
      |> Day5.Part1.update_satisfies_rules?(parsed_rules)
      |> Kernel.not()
    end)
    |> Enum.map(&fix_update(&1, parsed_rules))
    |> Enum.map(&Day5.Part1.get_middle_value/1)
    |> Enum.sum()
  end
end
