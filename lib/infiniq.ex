defmodule Infiniq do
  def start_link(name, work, opts \\ []) do
    import Supervisor.Spec

    children = [
      worker(Infiniq.Agent, [agent_opts(name, opts)]),
      supervisor(Infiniq.WorkerSupervisor,
                 [work, name, worker_opts(opts), worker_supervisor_opts(name, opts)])
    ]

    Supervisor.start_link(children, strategy: :one_for_all)
  end

  defdelegate push(work, items), to: Infiniq.Agent

  defp agent_opts(name, opts) do
    opts
    |> Keyword.take([])
    |> Keyword.put(:name, name)
  end

  defp worker_opts(opts) do
    opts
    |> Keyword.take([:wait])
  end

  defp worker_supervisor_opts(name, opts) do
    opts
    |> Keyword.take([:pool_size])
    |> Keyword.put(:name, worker_supervisor_name(name))
  end

  defp worker_supervisor_name(name), do: Module.concat(name, "WorkerSupervisor")
end
