# Advent of Code 2024 - Elixir Solution

This repository contains solutions for the [Advent of Code 2024](https://adventofcode.com/2024) programming puzzles, implemented in Elixir.

## Note about AI

I've chosen to use AI sparingly for this project.  In my mind, AI is here to stay and has changed the way I write code forever, so why not embrace it.  That said, the spirit of advent of code is learning and the challenge of developing algorithms.  For that reason, I'm limiting myself to using AI as a reference and for helping me organize my thoughts on approaches to problems.  I definitely failed a few times, getting maybe a little too much help from AI but I'm ok with that.  Learning to leverage AI is equally interesting and important to me as developing algorithms from scratch.  This is all about having fun anyway!

## Project Structure

```
advent_of_code_2024/
├── lib/
│   ├── days/           # Solutions for each day's puzzles
│   │   └── day_1/     # Example: Day 1 solutions
│   ├── mix/           # Custom mix tasks
│   └── advent_of_code2024.ex  # Main module
├── priv/
│   └── inputs/        # Puzzle input files
└── test/              # Test files
```

## Prerequisites

- Elixir ~> 1.17
- Mix (Elixir's build tool)

## Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd advent_of_code_2024
```

2. Install dependencies:
```bash
mix deps.get
```

## Running Solutions

There are two ways to run the solutions:

1. Run all solutions:
```bash
mix aoc
```

2. Run a specific day and part:
```bash
mix aoc <day> <part>
```

Example:
```bash
mix aoc 1 1  # Runs Day 1, Part 1
mix aoc 1 2  # Runs Day 1, Part 2
```

## Adding New Solutions

1. Create a new directory under `lib/days/` for each day
2. Add your input file in `priv/inputs/`
3. Create modules for each part following the existing pattern:
   - `Day<N>.ex` - Contains puzzle description and shared functionality
   - `Part1.ex` - Solution for part 1
   - `Part2.ex` - Solution for part 2
4. Add your new modules to the `@puzzles` list in `advent_of_code2024.ex`
