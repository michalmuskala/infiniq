defmodule InfiniqTest do
  use ExUnit.Case
  doctest Infiniq

  defmacrop unique_name do
    {function, _arity} = __CALLER__.function
    :"#{__CALLER__.module}.#{function}"
  end

  test "start_link" do
    name = unique_name
    {:ok, _} = Infiniq.start_link(name, {__MODULE__, :test_task, [self]})
  end

  test "runs a task" do
    name = unique_name
    start_link(name)
    Infiniq.push(name, [:ok])
    assert_receive :ok, 150
  end

  test "runs all tasks" do
    name = unique_name
    start_link(name)
    Infiniq.push(name, 1..50)
    Infiniq.push(name, 51..100)

    assert receive_all(1..100, 150)
  end

  defp receive_all([], _timeout), do: true
  defp receive_all(collection, timeout) do
    receive do
      n -> collection |> Enum.reject(&(&1 == n)) |> receive_all(timeout)
    after
      timeout -> false
    end
  end

  defp start_link(name) do
    {:ok, _} = Infiniq.start_link(name, {__MODULE__, :test_task, [self]}, wait: 0)
  end

  def test_task(item, pid) do
    send pid, item
  end
end
