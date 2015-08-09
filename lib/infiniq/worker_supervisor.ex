defmodule Infiniq.WorkerSupervisor do
  def start_link(agent, opts) do
    import Supervisor.Spec

    pool_size = Keyword.get(opts, :pool_size, 10)

    children =
      for id <- 1..pool_size,
        do: worker(Infiniq.Worker, [agent, opts], id: id)

    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
