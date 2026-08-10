# Contributing

## Commit Guidelines

- **Atomic and Unitary:** Each commit must represent a single logical change.
  *Example:*
  - Good: `Add #events method to Registry`
  - Bad: `Add #events method and refactor Dispatcher logic`
- **No Unrelated Changes:** Do not mix unrelated changes in the same commit.
- **Separate Refactoring:** Whenever possible, separate refactoring commits from new feature or bugfix commits.

## Pull Requests

- **Descriptive Summary:** Every PR must include a clear and descriptive summary of its purpose and changes.
- **PR Description Files:** If a description cannot be provided directly in the PR, generate a file with the PR description (e.g., `docs/agents/issues/<pr_number>_description.md`), but do not commit this file.

## Definition of Done for PRs

A PR is considered complete when:

- The stated objective has been achieved.
- All tests are passing.
- Rubocop passes without errors.
- Code coverage is as high as reasonably possible.
- YARD documentation coverage passes (`bundle exec rake verify_measurements`).
- Code is not overly complex:
  - Classes and methods should have clear, focused responsibilities.
  - If a class or method is taking on too many responsibilities, refactor to simplify.
  - Methods should be small and do exactly one thing. If a method is growing, extract parts into private helper methods or separate classes.
  - *Example:*
    ```ruby
    # Good: each method does one thing
    class Worker
      def run
        fetch_job
        process_job
      end

      private

      def fetch_job; end
      def process_job; end
    end

    # Bad: method does too much
    class Worker
      def run
        fetch_job
        process_job
        send_metrics
        cleanup
      end
    end
    ```
  - This requirement applies primarily to source code. For specs, refactor only if there is excessive duplication.

### CI Checks

This project is a single Ruby gem (no per-folder path filters in CI) — every change is checked against
the full suite below, taken from `.circleci/config.yml`:

| CircleCI Job | Local command(s) |
|--------------|-------------------|
| `test` | `bundle exec rspec` |
| `checks` | `rubocop` and `bundle exec rake verify_measurements` (YARD doc coverage via yardstick) |
| `build-and-release` | Not runnable locally — gem build/publish, only runs on tagged `main` after `test` and `checks` pass |

The `checks` job also runs `check_readme.sh`, `rubycritic.sh`, and `check_specs` inside the CI Docker
image (`darthjee/circleci_ruby_331`). These rely on scripts baked into that image and are not directly
runnable locally; `rubocop` and `rake verify_measurements` are the closest local equivalents, plus
manually confirming every new class has a corresponding spec (per `config/check_specs.yml`) and the
README/version docs are in sync.

If this project later grows into a multi-package/monorepo layout with path-filtered CI jobs, update this
table to map each top-level folder to the jobs and commands relevant to it, and include a step in issue
plans to identify affected folders before opening a PR.

## Code Organization

### File Responsibility: Class Declarers vs Scripts

Every source file (excluding test files) must act as a **class declarer** — it should define one or more
classes or modules. Files must not act as **scripts** (i.e., they must not execute logic at load time or
perform side effects directly).

This gem currently has no entrypoint scripts — `lib/jace.rb` only declares the `Jace` module and
`autoload`s its classes, so it does not execute logic at load time either. If an entrypoint script is
ever introduced (e.g. a CLI under `exe/`), document it here as the sole exception.

*Example:*
```ruby
# Good: class declarer — defines a class
class Router
  def register(app); end
end

# Bad: script — executes logic at file-load time
router = Router.new
router.register(app)
```

Test files are exempt from this rule and may execute setup code freely.

### File Naming: snake_case Matching the Class Name

Files that define a class or module must use **snake_case** naming, matching the class/module name.

*Examples:*

- `registry.rb` for `class Registry`
- `dispatcher.rb` for `class Dispatcher`
- `executer.rb` for `class Executer`

This applies to both source files and their corresponding spec files, mirroring `lib/` under `spec/lib/`:
- `lib/jace/registry.rb` → spec: `spec/lib/jace/registry_spec.rb`
- `lib/jace/dispatcher.rb` → spec: `spec/lib/jace/dispatcher_spec.rb`

Non-class files (e.g. utility modules of module-level methods) use lowercase/snake_case at the author's discretion.

### Method Order: Public Before Private

Within a class, **public methods must be declared before private methods**. Private methods (after a
`private` keyword) serve as implementation helpers and should appear at the end of the class body.

*Example:*
```ruby
# Good: public methods first, private methods last
class Worker
  def run
    prepare
    execute
  end

  def status; end

  private

  def prepare; end
  def execute; end
end

# Bad: private methods mixed in with or before public methods
class Worker
  private

  def prepare; end

  public

  def run; end
end
```

## Dependency Injection

Classes must receive their dependencies (data, configuration, collaborators) as constructor arguments. A
class must never reach out to load files, read environment variables, or fetch configuration on its own.

**The entry point (or the calling code) is the only place responsible for loading configuration** (e.g.
reading a YAML file, parsing options). It then passes the loaded data down to the classes that need it.

This makes every class independently testable: tests simply instantiate the class with the data they
need, without touching the filesystem or environment.

*Example:*
```ruby
# Good: class receives its context/data as arguments — easy to test
class Dispatcher
  def initialize(before: [], after: [])
    @before = [before].flatten.compact
    @after = [after].flatten.compact
  end
end

# Bad: class loads its own config — hard to test and couples to the filesystem
class Dispatcher
  def initialize
    @before = YAML.load_file('./before.yml') # ❌
  end
end
```

This principle applies to all classes — including handlers and registries. If a class needs data, it
gets it through its constructor.

## Refactoring Guidelines

When refactoring, aim to:

- **Reduce Code Duplication:**
  *Example:* Move repeated spec setup into a shared context or factory method.
  ```ruby
  # Good
  def build_context(name: 'Books')
    SomeContext.new(name: name)
  end
  # In specs:
  let(:context) { build_context(name: 'Games') }

  # Bad
  let(:context) { SomeContext.new(name: 'Games') }
  # ...repeated setup duplicated across many spec files
  ```
- **Simplify Conditionals:** Prefer early returns / guard clauses over deeply nested `if`/`else`.
- **Extract Collaborators:** When a class starts coordinating too many concerns, extract a new
  class instead of growing the existing one (see `Jace::Registry` → `Jace::Dispatcher` → `Jace::Executer`
  → `Jace::Handler` as an example of this decomposition).
