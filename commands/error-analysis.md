# Error Analysis

Diagnose an error's root cause and propose the smallest fix.

## Input

`$ARGUMENTS` — error message, stack trace, log excerpt, or one-line symptom.

## Workflow

1. **Read the error verbatim**: full stack trace, error code, surrounding log lines, request context.
2. **Locate the throw site**: open the file at `frame:line`, read enough surrounding code to understand the call.
3. **Trace upward** to find where the bad state was introduced. The throw site is rarely the bug.
4. **Form one hypothesis** and name what would falsify it. Test cheaply (read code, run a probe, check input).
5. **Propose the minimal fix** at the right layer. Don't paper over symptoms with `try/catch` at the throw site.

## Diagnosis checklist

- **Reproducibility**: deterministic, intermittent, environment-specific?
- **When did it start**: recent deploy, config change, dependency upgrade?
- **What input triggers it**: minimal repro case?
- **Boundary or invariant violated**: null where non-null expected, ordering assumption, race?
- **Error type fit**: does the exception name match what's actually wrong, or is it being raised in a misleading place?

## Output

- **Symptom**: one sentence
- **Root cause**: with evidence (`file:line`, log line, repro steps)
- **Fix**: smallest change that removes the cause, with `file:line`
- **Regression test**: if the bug class can recur, propose one — don't write it unless asked
- **Related risk**: similar code paths that might have the same bug

## Constraints

- Fix the cause, not the symptom. Don't wrap throwing code in `try/catch` as the primary fix.
- **Don't add retry, circuit breaker, fallback, or graceful degradation unless the user explicitly asks.** These are architectural decisions, not error-fix scope.
- **Don't add validation for inputs that come from internal callers.** Validate only at system boundaries (user input, external APIs).
- Don't propose adding Sentry / monitoring / alerting unless the user is debugging a production incident and explicitly asks for telemetry.
- Don't refactor surrounding code while diagnosing. List unrelated smells as follow-ups; don't fix them.
