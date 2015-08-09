defmodule Infiniq.Agent do
  def start_link(opts \\ []) do
    Agent.start_link(fn -> :queue.new end, opts)
  end

  def pop(agent) do
    Agent.get_and_update(agent, fn queue ->
      case :queue.out(queue) do
        {{:value, item}, new} -> {{:ok, item}, new}
        {:empty, new}         -> {:error, new}
      end
    end)
  end

  def push(agent, items) do
    Agent.update(agent, fn queue ->
      Enum.reduce(items, queue, &:queue.in/2)
    end)
  end

  def length(agent) do
    Agent.get(agent, &:queue.len/1)
  end
end
