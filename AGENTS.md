# GitHub Copilot Instructions for Jace

## Project Overview

**Jace** is a Ruby gem designed for event-driven development **within a single application**.
It is not about distributed architecture or message queues — it is about building internal
event-oriented logic inside a Ruby gem or application.

With Jace, you register handlers for named events and trigger those events later. When an
event is triggered, Jace executes the registered `before` handlers, then the main block,
then the `after` handlers — all within a given context object.

### Core classes

- **`Jace::Registry`** — stores event-to-handler mappings and exposes `register` and
  `trigger` methods.
- **`Jace::Dispatcher`** — holds `before` and `after` handler lists for a single event
  and delegates execution to `Jace::Executer`.
- **`Jace::Executer`** — runs the before handlers, the main block, and the after handlers
  inside a given context.
- **`Jace::Handler`** — wraps a `Symbol` (method name) or `Proc` into a callable unit
  that evaluates within a context via `instance_eval`.

### Typical usage

```ruby
registry = Jace::Registry.new
context  = SomeContext.new

registry.register(:payment_processed, :before) { notify_fraud_service }
registry.register(:payment_processed)          { send_receipt }

registry.trigger(:payment_processed, context) do
  process_payment
end
# Runs: notify_fraud_service → process_payment → send_receipt
```

---

## Language

All code, comments, documentation, commit messages, PR titles, PR descriptions, and review
comments **must be written in English**.

---

## Testing

- Every new class or module **must have a corresponding RSpec spec file**.
- Specs mirror the source tree: `lib/jace/foo.rb` → `spec/lib/jace/foo_spec.rb`.
- Files that are intentionally excluded from spec coverage (e.g. `version.rb`) are listed
  in `config/check_specs.yml`. Add any new file that genuinely does not need a spec to that
  list; otherwise write the spec.
- Write **unit specs** for individual classes and **integration specs** under
  `spec/integration/` for end-to-end scenarios (README examples, YARD examples).
- Each `it` block should have **one expectation** whenever possible.
- Use `let`, `subject`, and `described_class` to keep examples readable and DRY.

---

## Documentation

All project documentation lives under [`docs/agents/`](docs/agents/):

| File | Contents |
|------|----------|
| [Folder Structure](docs/agents/folder-structure.md) | Top-level directory layout and the role of each folder. |
| [Architecture](docs/agents/architecture.md) | Source layout, modules, code style, and implementation guidelines. |
| [Flow](docs/agents/flow.md) | Main runtime flow of the application. |
| [Contributing](docs/agents/contributing.md) | Commit guidelines, PR standards, code organization, and refactoring rules. |
| [Plans](docs/agents/plans/) | Implementation plans for ongoing or upcoming features. |
| [Issues](docs/agents/issues/) | Detailed specs for open issues. |

### Issues (`docs/agents/issues/`)

Each file documents an issue in detail. Naming convention:

```
docs/agents/issues/<issue_id>_<issue_name>.md
```

Example: `docs/agents/issues/5_release_docker_image.md` for issue #5.

### Plans (`docs/agents/plans/`)

Each plan is a directory named after the issue ID and topic, containing one or more related files:

```
docs/agents/plans/<issue_id>_<topic>/<related_files>.md
```

Example: `docs/agents/plans/12_add-auth/plan.md` for issue #12.

---

## Documentation Standards

- All public classes, modules, and methods **must be documented with [YARD](https://yardoc.org/)**.
- Use the following YARD tags where applicable:
  - `@param name [Type] description`
  - `@return [Type] description`
  - `@example` with working Ruby code
  - `@api public` / `@api private`
  - `@author`
- Private methods and internal helpers should carry at least a brief description so
  developers can understand intent without reading implementation details.
- Keep examples in YARD docs consistent with the specs under `spec/integration/yard/`.

---

## Code Style and Design

### Single Responsibility (Sandi Metz / 99 Bottles)

- Classes and methods should do **one thing**.
- Prefer many small, well-named methods over a few large ones.
- If a method needs a comment to explain *what* it does (not *why*), it should probably be
  extracted into its own method.
- Aim for methods that fit on a screen without scrolling.

### Law of Demeter

- Objects should only talk to their **immediate collaborators**.
- Avoid chaining method calls across object boundaries (e.g. `a.b.c.d`).
- If you need data from a distant object, add a delegation method or restructure the
  dependency.

### General conventions

- Use `frozen_string_literal: true` at the top of every Ruby file.
- Prefer `attr_reader` over direct ivar access in the body of methods.
- New public methods added to `Jace` classes must be covered by specs and YARD docs before
  the PR is considered complete.
