defmodule AdventOfCode2024.Application do
  use Application

  def start(_type, _args) do
    children = []

    opts = [strategy: :one_for_one, name: AdventOfCode2024.Supervisor]
    supervisor = Supervisor.start_link(children, opts)

    AdventOfCode2024.run_all()

    supervisor
  end
end
