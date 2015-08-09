# Infiniq

Infiniq (pronounced: infini-queue) is an attempt to create a simple library to
ease parallelizing repetitive jobs in a situation of constrained resources.

## Installation

  1. Add infiniq to your list of dependencies in mix.exs:

        def deps do
          [{:infiniq, github: "michalmuskala/infiniq"}]
        end

  2. Ensure infiniq is started before your application:

        def application do
          [applications: [:infiniq]]
        end

## TODO

  * A way to monitor if task was really finished by a worker
  * Provide different strategies: "at least one" and "at most one" runs
    (currently we have at most one)
  * Other backends for queuing tasks - ets and other (redis?)
