defmodule DiningPhilosophers.Application do
  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias DiningPhilosophers.{Spoon, Philosopher}

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: DiningPhilosophers.Worker.start_link(arg1, arg2, arg3)
      # worker(DiningPhilosophers.Worker, [arg1, arg2, arg3]),
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

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DiningPhilosophers.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
