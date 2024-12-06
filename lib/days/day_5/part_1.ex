defmodule AdventOfCode2024.Day5.Part1 do
  @moduledoc """
  To get the printers going as soon as possible, start by identifying which updates are already in the right order.

  In the above example, the first update (75,47,61,53,29) is in the right order:

  75 is correctly first because there are rules that put each other page after it: 75|47, 75|61, 75|53, and 75|29.
  47 is correctly second because 75 must be before it (75|47) and every other page must be after it according to 47|61, 47|53, and 47|29.
  61 is correctly in the middle because 75 and 47 are before it (75|61 and 47|61) and 53 and 29 are after it (61|53 and 61|29).
  53 is correctly fourth because it is before page number 29 (53|29).
  29 is the only page left and so is correctly last.
  Because the first update does not include some page numbers, the ordering rules involving those missing page numbers are ignored.

  The second and third updates are also in the correct order according to the rules. Like the first update, they also do not include every page number, and so only some of the ordering rules apply - within each update, the ordering rules that involve missing page numbers are not used.

  The fourth update, 75,97,47,61,53, is not in the correct order: it would print 75 before 97, which violates the rule 97|75.

  The fifth update, 61,13,29, is also not in the correct order, since it breaks the rule 29|13.

  The last update, 97,13,75,29,47, is not in the correct order due to breaking several rules.

  For some reason, the Elves also need to know the middle page number of each update being printed. Because you are currently only printing the correctly-ordered updates, you will need to find the middle page number of each correctly-ordered update. In the above example, the correctly-ordered updates are:

  75,47,61,53,29
  97,61,53,29,13
  75,29,13
  These have middle page numbers of 61, 53, and 29 respectively. Adding these page numbers together gives 143.

  Of course, you'll need to be careful: the actual list of page ordering rules is bigger and more complicated than the above example.

  Determine which updates are already in the correct order. What do you get if you add up the middle page number from those correctly-ordered updates?
  """

  @behaviour AdventOfCode2024.Puzzle

  alias AdventOfCode2024.Day5

  @doc """
  Parse a single rule into a tuple of {left_page, right_page}.
  """
  def parse_rule(rule) do
    [left, right] = String.split(rule, "|")
    {left, right}
  end

  @doc """
  Parse the input file into a tuple of {parsed_rules, updates}.
  Rules are converted to tuples of {left_page, right_page}.
  """
  def parse_input(input) do
    [rules, updates] = String.split(input, "\n\n", trim: true)

    parsed_rules =
      rules
      |> String.split("\n", trim: true)
      |> Enum.map(&parse_rule/1)

    updates = String.split(updates, "\n", trim: true)

    {parsed_rules, updates}
  end

  @doc """
  Convert an update string into a map of page numbers to their positions.
  """
  def index_update(update) do
    update
    |> String.split(",")
    |> Enum.with_index()
    |> Map.new()
  end

  @doc """
  Check if an update's indexes satisfy all given parsed rules.
  """
  def update_satisfies_rules?(indexes, parsed_rules) do
    Enum.all?(parsed_rules, fn {left, right} ->
      left_idx = indexes[left]
      right_idx = indexes[right]

      if left_idx && right_idx do
        left_idx < right_idx
      else
        true
      end
    end)
  end

  @doc """
  Split an update string into a list of page numbers.
  """
  def parse_update(update) do
    update |> String.split(",")
  end

  @doc """
  Get the middle value from a list of page numbers.
  Converts the middle element to an integer.
  """
  def get_middle_value(list) do
    list
    |> Enum.at(div(length(list), 2))
    |> String.to_integer()
  end

  def solve do
    {parsed_rules, updates} = parse_input(Day5.input_file())

    updates
    |> Enum.filter(fn update ->
      update
      |> index_update()
      |> update_satisfies_rules?(parsed_rules)
    end)
    |> Enum.map(&parse_update/1)
    |> Enum.map(&get_middle_value/1)
    |> Enum.sum()
  end
end
