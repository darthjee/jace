# Folder Structure

## Project Root

| Directory / File | Description |
|-----------------|-------------|
| `lib/`          | Gem source code — `Jace::Registry`, `Jace::Dispatcher`, `Jace::Executer`, `Jace::Handler`, and version info. |
| `spec/`         | RSpec test suite — unit specs (mirroring `lib/`) and integration specs. |
| `config/`       | Tooling config: `check_specs.yml` (spec-coverage exclusions), `yardstick.rb`/`yardstick.yml` (YARD doc-coverage), `rubycritc.rb`. |
| `docs/`         | Project documentation, including the `agents/` folder consumed by AI coding agents. |
| `.github/`      | GitHub-specific files: Copilot instructions, PR/commit templates, and `jace-usage.md`. |
| `.circleci/`    | CircleCI pipeline configuration (`config.yml`). |
| `AGENTS.md`     | Shared instructions for AI coding agents (Claude, Copilot). |
| `CLAUDE.md`     | Pointer to `AGENTS.md`. |
| `README.md`     | Project overview, installation, and usage examples. |
| `jace.gemspec`  | Gem specification. |
| `Gemfile` / `Gemfile.lock` | Bundler dependency management. |
| `Rakefile`      | Rake tasks (tests, docs, etc.). |
| `Makefile`      | Developer convenience commands. |
| `Dockerfile` / `docker-compose.yml` | Containerized dev/test environment. |
| `.rubocop.yml` / `.rubocop_todo.yml` | RuboCop style-check configuration. |
| `jace.png`      | Project logo, used in `README.md`. |
| `LICENSE`       | Project license. |

## lib/jace (gem source)

| File | Description |
|------|--------------|
| `registry.rb`   | `Jace::Registry` — stores event-to-handler mappings; exposes `register` and `trigger`. |
| `dispatcher.rb` | `Jace::Dispatcher` — holds `before`/`after` handler lists for one event, delegates execution to `Executer`. |
| `executer.rb`   | `Jace::Executer` — runs before handlers, the main block, then after handlers within a context. |
| `handler.rb`    | `Jace::Handler` — wraps a `Symbol` or `Proc` into a callable evaluated via `instance_eval`. |
| `version.rb`    | Gem version constant. |

## docs/agents

| Subdirectory / File | Description |
|----------------------|-------------|
| `architecture.md`      | System architecture overview for agents. |
| `flow.md`               | Key workflows/data flow through the system. |
| `folder-structure.md`  | This file — top-level directory layout. |
| `issue-enhancement.md` | Guidance for enhancing/refining issues. |
| `issues/`              | Structured issue files consumed by the planning/fixing pipeline. |
| `plans/`               | Implementation plans generated for issues. |

## spec

| Subdirectory | Description |
|---------------|-------------|
| `lib/`         | Unit specs mirroring `lib/jace/*.rb`. |
| `integration/` | End-to-end specs: `readme/` (validates README examples) and `yard/` (validates YARD `@example` code). |
| `support/`     | Shared spec helpers: `models/` (test fixtures/contexts) and `shared_examples/`. |
