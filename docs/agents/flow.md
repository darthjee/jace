# Flow

## Overview

Jace runs one in-process cycle per triggered event: `before` handlers, then the main
block, then `after` handlers. There is no queueing or I/O — everything happens
synchronously in the caller's thread.

## Registration

1. `Registry#register(event, instant = :after, &block)` normalizes `event` to a Symbol
   and finds or creates the event's `Dispatcher`.
2. The block is appended to that dispatcher's `before` or `after` list (chosen by
   `instant`).

## Trigger

1. `Registry#trigger(event, context, &block)` looks up the event's dispatcher, falling
   back to an empty `Dispatcher` when nothing was registered for it.
2. `Dispatcher#dispatch(context, &block)` calls
   `Executer.call(before:, after:, context:, &block)`.
3. `Executer#call`:
   - wraps each `before` entry in a `Jace::Handler` and runs it via
     `context.instance_eval`;
   - calls the main block (if given) and keeps its result;
   - wraps and runs each `after` entry the same way.
4. The main block's return value is returned to the caller of `trigger`.
