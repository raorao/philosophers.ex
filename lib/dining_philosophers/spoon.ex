defmodule DiningPhilosophers.Spoon do
  use GenServer
  require Logger


  def start_link(id) do
    GenServer.start_link(__MODULE__, :ok, name: id)
  end

  def pick_up(id, philosopher) do
    GenServer.call id, {:pick_up, philosopher}
  end

  def drop(id, philosopher) do
    GenServer.cast id, {:drop, philosopher}
  end

  def init(:ok) do
    {:ok, :unowned}
  end

  def handle_call({:pick_up, philosopher}, _from, :unowned) do
    {:reply, :ok, philosopher}
  end

  def handle_call({:pick_up, _philosopher}, _from, owner) do
    {:reply, :error, owner}
  end


  def handle_cast({:drop, owner}, owner) do
    {:noreply, :unowned}
  end
end
