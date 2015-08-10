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

## License

Copyright 2015 Michał Muskała

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
