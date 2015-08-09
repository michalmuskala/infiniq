defmodule Infiniq.AgentTest do
  use ExUnit.Case, async: true

  alias Infiniq.Agent

  setup do
    {:ok, pid} = Agent.start_link
    {:ok, agent: pid}
  end

  test "push", %{agent: agent} do
    assert :ok == Agent.push(agent, [1, 2, 3])
  end

  test "pop", %{agent: agent} do
    Agent.push(agent, [1, 2, 3])

    assert 1 == Agent.pop(agent)
    assert 2 == Agent.pop(agent)
    assert 3 == Agent.pop(agent)
    assert nil == Agent.pop(agent)
  end

  test "length", %{agent: agent} do
    assert 0 == Agent.length(agent)
    Agent.push(agent, [1, 2, 3])
    assert 3 == Agent.length(agent)
  end

  test "concurrent", %{agent: agent} do
    Agent.push(agent, [1, 2, 3])
    t1 = Task.async(fn -> Agent.pop(agent) end)
    t2 = Task.async(fn -> Agent.push(agent, 4..20) end)
    items =
      for _ <- 1..10,
        task = Task.async(fn -> Agent.pop(agent) end),
        item = Task.await(task),
        do: item
    item = Task.await(t1)
    Task.await(t2)

    assert 20 == length(List.wrap(item)) + length(items) + Agent.length(agent)
  end
end
