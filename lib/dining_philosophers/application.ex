defmodule DiningPhilosophers.Application do
  @moduledoc false

  use Application
  alias DiningPhilosophers.{Utensil, Philosopher}

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Utensil, [:fork], id: :fork, name: :fork, restart: :transient),
      worker(Utensil, [:spoon], id: :spoon, restart: :transient),
      worker(Utensil, [:chopstick], id: :chopstick, restart: :transient),
      worker(Utensil, [:knife], id: :knife, restart: :transient),
      worker(Utensil, [:spork], id: :spork, restart: :transient),
      worker(Philosopher, ["Simone de Beauvoir", :fork, :spoon], id: :simone, restart: :transient),
      worker(Philosopher, ["Hannah Arendt", :spoon, :chopstick], id: :hannah, restart: :transient),
      worker(Philosopher, ["Elizabeth Anscombe", :chopstick, :knife], id: :elizabeth, restart: :transient),
      worker(Philosopher, ["Philippa Foot", :knife, :spork], id: :philippa, restart: :transient),
      worker(Philosopher, ["Anne Conway", :spork, :fork], id: :anne, restart: :transient),
    ]

    opts = [strategy: :one_for_one, name: DiningPhilosophers.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
