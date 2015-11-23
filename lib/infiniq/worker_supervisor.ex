defmodule Infiniq.WorkerSupervisor do
  def start_link(work, agent_name, worker_opts, opts) do
    import Supervisor.Spec

    {pool_size, opts} = Keyword.pop(opts, :pool_size, 10)

    children =
      for id <- 1..pool_size,
        do: worker(Infiniq.Worker, [work, agent_name, worker_opts], id: id)

    Supervisor.start_link(children, opts ++ [strategy: :one_for_one])
  end
end
