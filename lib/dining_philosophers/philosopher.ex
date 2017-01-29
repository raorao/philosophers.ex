defmodule DiningPhilosophers.Philosopher do
  use GenServer
  require Logger
  alias DiningPhilosophers.Spoon

  def start_link(name, left_spoon, right_spoon) do
    initial_state = %{
      name: name,
      left_spoon: left_spoon,
      right_spoon: right_spoon,
      health: 20
    }
    GenServer.start_link(__MODULE__, initial_state, name: :"#{name}")
  end

  def init(initial_state) do
    schedule_check()
    {:ok, initial_state}
  end

  def handle_info(
    :eat,
    state = %{
      name: name,
      left_spoon: left_spoon,
      right_spoon: right_spoon
    }
  ) do
    Logger.info("#{name} has eaten. Her health is now 20.")
    Spoon.drop(left_spoon, name)
    Spoon.drop(right_spoon, name)

    {:noreply, %{state | health: 20}}
  end


  def handle_info(:check, state = %{name: name, health: 0}) do
    Logger.warn("#{name} has starved.")
    {:stop, :normal, state}
  end

  def handle_info(
    :check,
    state = %{
      name: name,
      left_spoon: left_spoon,
      right_spoon: right_spoon,
      health: health
    }
  ) do
    case Spoon.pick_up(left_spoon, name) do

      :ok ->
        case Spoon.pick_up(right_spoon, name) do
          :ok ->
            Logger.debug("#{name} is ready to eat!")
            eat()

          :error ->
            Logger.debug("#{name} failed to pick up spoon #{right_spoon}. dropping #{left_spoon}.")
            Spoon.drop(left_spoon, name)
        end

      :error ->
        Logger.debug("#{name} failed to pick up spoon #{left_spoon}.")
    end

    schedule_check()

    Logger.debug("#{name}'s health is #{health - 1}.")

    {:noreply, %{state | health: health - 1}}
  end

  defp eat() do
    Process.send_after self(), :eat, 1000
  end

  defp schedule_check do
    interval = 1500 + :rand.uniform(1000)
    Process.send_after self(), :check, interval
  end
end
