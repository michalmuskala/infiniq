defmodule Infiniq do
  def start_link(work, opts \\ []) do
    import Supervisor.Spec

    {sup_opts, pool_opts, agent_opts} = split_opts(opts, work)

    {:ok, sup} = Supervisor.start_link(sup_opts, strategy: :one_for_all)

    agent_spec = worker(Infiniq.Agent, [agent_opts])
    {:ok, agent} = Supervisor.start_child(sup, agent_spec)
    pool_spec = supervisor(Infiniq.WorkerSupervisor, [agent, pool_opts])
    {:ok, _} = Supervisor.start_child(sup, pool_spec)

    {:ok, sup}
  end

  defp split_opts(opts, work) do
    sup_opts   = Keyword.drop(opts, ~w(agent_name pool_size)a)
    pool_opts  = Keyword.take(opts, ~w(pool_size)a) ++ [work: work]
    agent_opts =
      case Keyword.fetch(opts, :agent_name) do
        {:ok, name} -> [name: name]
        :error      -> []
      end
    {sup_opts, pool_opts, agent_opts}
  end
end
