# Debug and Trace Setup

Help the user set up debugging or distributed tracing for the current project — without inventing tools they don't use.

## Input

`$ARGUMENTS` — the situation. Examples: "intermittent 500s in checkout", "set up OpenTelemetry", "add a debugger config for my Python service".

## Workflow

1. **Identify the stack**: read `package.json` / `pyproject.toml` / `go.mod` / `Cargo.toml` and the runtime hint from existing config (`Dockerfile`, k8s manifests, `.env.example`). Don't assume Node.js.
2. **Identify what's already there**: existing logger, existing tracing SDK, existing IDE debug configs. Reuse, don't replace.
3. **Match the request to one of these tracks**:
   - **Local debugger**: IDE breakpoint setup (VS Code `launch.json`, PyCharm, GoLand, etc.)
   - **Structured logging**: replace `print` / `console.log` with the project's logger; add correlation IDs
   - **Distributed tracing**: OpenTelemetry SDK + exporter (Jaeger, Tempo, Honeycomb, vendor-specific)
   - **Profiling**: CPU / heap profile capture for a hot path
   - **Production incident debug**: temporary verbose logging gated by env var or feature flag, with a removal plan
4. **Propose the smallest config change** that addresses the actual request. Ask before adding new dependencies.
5. **Verify**: show how to trigger the instrumentation and confirm output (curl + log line, span in Jaeger UI, breakpoint hit in IDE).

## Output

- **Files changed or created**: list with one-line purpose each
- **Dependencies added**: name, version, reason
- **How to run**: exact command to trigger the debug / trace path
- **How to verify**: what the user should see
- **Cleanup**: what to remove when the investigation is done (especially for production verbose logging)

## Constraints

- No prebuilt boilerplate for stacks the user isn't on.
- No nine-section "debug dashboard" unless the user asked for a dashboard.
- If the user's project already has tracing / logging configured, extend it instead of replacing it.
- Tracing without a destination is noise — confirm the backend (Jaeger / Tempo / Datadog / etc.) before instrumenting.
