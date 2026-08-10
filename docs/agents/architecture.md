# Architecture

## Overview

Jace is a small, dependency-free Ruby gem for in-process, event-driven logic. Consumers
build a `Jace::Registry`, register `before`/`after` handlers for named events, then
`trigger` an event around a block. Jace runs the `before` handlers, the block, and the
`after` handlers in sequence, all evaluated within a caller-supplied context object via
`instance_eval`. There is no persistence, queueing, or I/O — the whole library is
in-memory coordination of Procs/Symbols.

## Source Code Layout

All application source code lives under `lib/`.

### `lib/jace.rb`

Entry point. Declares the `Jace` module and `autoload`s each class so requiring
`jace` doesn't eagerly load the whole library.

### `lib/jace/registry.rb`

`Jace::Registry` — the public API. Maps event names to `Dispatcher` instances.
`register(event, instant = :after, &block)` adds a handler; `trigger(event, context, &block)`
looks up (or defaults) the dispatcher for the event and runs it against the block and context.

### `lib/jace/dispatcher.rb`

`Jace::Dispatcher` — holds the `before` and `after` handler lists for a single event.
`dispatch(context, &block)` delegates the actual run to `Jace::Executer.call`.

### `lib/jace/executer.rb`

`Jace::Executer` — runs one event cycle: executes the `before` handlers, calls the
block, then executes the `after` handlers, returning the block's result. Each raw
handler entry (`Symbol` or `Proc`) is wrapped into a `Jace::Handler` before being run
via `context.instance_eval`.

### `lib/jace/handler.rb`

`Jace::Handler` — wraps a single `Symbol` (method name) or `Proc` into a callable
(`#call(context)` / `#to_proc`) that evaluates within the given context.

### `lib/jace/version.rb`

Gem version constant (`Jace::VERSION`).
