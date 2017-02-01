defmodule DiningPhilosophers.Philosopher do
  use GenServer
  require Logger
  alias DiningPhilosophers.Utensil

  def start_link(name, left_utensil, right_utensil) do
    initial_state = %{
      name: name,
      left_utensil: left_utensil,
      right_utensil: right_utensil,
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
      left_utensil: left_utensil,
      right_utensil: right_utensil
    }
  ) do
    Logger.info("#{name} has eaten. Her health is now 20. Dropping utensils.")
    Utensil.drop(left_utensil, name)
    Utensil.drop(right_utensil, name)

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
      left_utensil: left_utensil,
      right_utensil: right_utensil,
      health: health
    }
  ) do
    case Utensil.pick_up(left_utensil, name) do

      :ok ->
        case Utensil.pick_up(right_utensil, name) do
          :ok ->
            Logger.debug("#{name} is ready to eat!")
            eat()

          :error ->
            Logger.debug("#{name} failed to pick up the #{right_utensil}. dropping the #{left_utensil}.")
            Utensil.drop(left_utensil, name)
        end

      :error ->
        Logger.debug("#{name} failed to pick up the #{left_utensil}.")
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
