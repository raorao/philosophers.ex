defmodule DiningPhilosophers.Spoon do
  use GenServer
  require Logger


  def start_link(id) do
    GenServer.start_link(__MODULE__, :ok, name: id)
  end

  def pick_up(id, philosopher) do
    if GenServer.whereis(id) do
      GenServer.call id, {:pick_up, philosopher}
    else
      :error
    end
  end

  def drop(id, philosopher) do
    if GenServer.whereis(id) do
      GenServer.cast id, {:drop, philosopher}
    end
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
