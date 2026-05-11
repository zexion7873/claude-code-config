# Refactor and Clean

Refactor code for clarity and correctness without expanding scope.

## Input

`$ARGUMENTS` — file path, function name, or scope to refactor; optional refactor goal (e.g. "extract IO from logic", "kill duplicated parsing").

## Workflow

1. **Read the target** plus its callers and tests. Refactor without tests is risky — flag missing coverage explicitly before changing behavior-sensitive code.
2. **Identify the actual smell** in one sentence. Don't run a generic checklist; name what's wrong here, in this code.
3. **Propose the smallest change** that removes the smell. Resist bundling unrelated cleanup.
4. **Apply the change** as one logical step. If the refactor needs multiple commits, say so before starting.
5. **Verify**: run tests, linter, type checker. If tests don't exist for the touched behavior, write characterization tests first.

## Smells worth chasing

- **Duplication**: repeated logic across files — extract only when the abstraction is obvious from the second instance
- **Long function doing several things**: split by responsibility, not by line count
- **Hidden coupling**: function reads / writes outside its parameters — make dependencies explicit
- **Bad name**: identifier doesn't match what the code does
- **Misplaced logic**: validation in controller, business rule in view, IO mixed with pure logic
- **Dead code**: unused branches, parameters, exports, imports

## Smells to ignore (unless asked)

- Length thresholds (functions can be long if they have one job)
- Premature abstraction (3 similar lines is fine; extract on the 4th)
- SOLID compliance for its own sake
- Test coverage percentage as a target

## Output

- **Smell**: one sentence — what's wrong, where (`file:line`)
- **Refactor**: the change applied, with `file:line` references
- **Trade-off**: what got worse to make this better (it always exists)
- **Tests run**: which suites passed / failed after the change
- **Follow-ups**: smells noticed but not fixed — list them, don't fix them

## Constraints

- One refactor per turn. Don't bundle unrelated cleanup with the requested change.
- **Don't add backward-compat shims, deprecation wrappers, or feature flags unless the user explicitly asks.** Change the code directly.
- Don't add comments that restate the renamed identifier — the rename should be enough.
- Don't add tests for behavior outside the refactor's scope; only add characterization tests if they're needed to verify the refactor itself.
- Refactor ≠ feature work. Don't add error handling, validation, or logging beyond what's already there.
