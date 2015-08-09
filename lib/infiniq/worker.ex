defmodule Infiniq.Worker do
  use GenServer

  def start_link(agent, opts) do
    GenServer.start_link(__MODULE__, [agent, opts])
  end

  ## Callbacks

  def init([agent, opts]) do
    wait = Keyword.get(opts, :wait, 100)
    work = Keyword.fetch!(opts, :work)

    {:ok, %{agent: agent, work: work, wait: wait}, 0}
  end

  def handle_info(:timeout, %{agent: agent, wait: wait} = state) do
    case Infiniq.Agent.pop(agent) do
      {:ok, value} ->
        send(self, {:work, value})
        {:noreply, state}
      :error ->
        {:noreply, state, wait}
    end
  end

  def handle_info({:work, value}, %{work: {mod, fun, args}, wait: wait} = state) do
    case apply(mod, fun, [value | args]) do
      :ok ->
        {:noreply, state, wait}
      {:error, reason} ->
        raise reason
    end
  end
end
