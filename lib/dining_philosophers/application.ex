defmodule DiningPhilosophers.Application do
  @moduledoc false

  use Application
  alias DiningPhilosophers.{Spoon, Philosopher}

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Spoon, [:spoon_one], id: :spoon_one, restart: :transient),
      worker(Spoon, [:spoon_two], id: :spoon_two, restart: :transient),
      worker(Spoon, [:spoon_three], id: :spoon_three, restart: :transient),
      worker(Spoon, [:spoon_four], id: :spoon_four, restart: :transient),
      worker(Spoon, [:spoon_five], id: :spoon_five, restart: :transient),
      worker(Philosopher, ["Simone de Beauvoir", :spoon_one, :spoon_two], id: :simone, restart: :transient),
      worker(Philosopher, ["Hannah Arendt", :spoon_two, :spoon_three], id: :hannah, restart: :transient),
      worker(Philosopher, ["Elizabeth Anscombe", :spoon_three, :spoon_four], id: :elizabeth, restart: :transient),
      worker(Philosopher, ["Philippa Foot", :spoon_four, :spoon_five], id: :philippa, restart: :transient),
      worker(Philosopher, ["Anne Conway", :spoon_five, :spoon_one], id: :anne, restart: :transient),
    ]

    opts = [strategy: :one_for_one, name: DiningPhilosophers.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
