defmodule Infiniq.Worker do
  use GenServer

  def start_link(work, agent, opts) do
    GenServer.start_link(__MODULE__, {work, agent, opts})
  end

  ## Callbacks

  def init({work, agent, opts}) do
    wait = Keyword.get(opts, :wait, 1000)

    {:ok, %{agent: agent, work: work, wait: wait}, 0}
  end

  def handle_info(:timeout, %{agent: agent, work: work, wait: wait} = state) do
    case Infiniq.Agent.pop(agent) do
      {:ok, value} ->
        work(work, value)
        {:noreply, state, 0}
      :error ->
        {:noreply, state, wait}
    end
  end

  defp work({module, fun, args}, value) do
    apply(module, fun, [value | args])
  end
end
