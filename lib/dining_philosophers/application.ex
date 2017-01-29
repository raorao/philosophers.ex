defmodule DiningPhilosophers.Application do
  @moduledoc false

  use Application
  alias DiningPhilosophers.{Spoon, Philosopher}

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Spoon, [:one], id: :one),
      worker(Spoon, [:two], id: :two),
      worker(Spoon, [:three], id: :three),
      worker(Spoon, [:four], id: :four),
      worker(Spoon, [:five], id: :five),
      worker(Philosopher, ["Simone de Beauvoir", :one, :two], id: :simone, restart: :transient),
      worker(Philosopher, ["Hannah Arendt", :two, :three], id: :hannah, restart: :transient),
      worker(Philosopher, ["Elizabeth Anscombe", :three, :four], id: :elizabeth, restart: :transient),
      worker(Philosopher, ["Philippa Foot", :four, :five], id: :philippa, restart: :transient),
      worker(Philosopher, ["Anne Conway", :five, :one], id: :anne, restart: :transient),
    ]

    opts = [strategy: :one_for_one, name: DiningPhilosophers.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
