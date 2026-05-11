# Code Explanation

Explain code at the level the user actually needs — no more, no less.

## Input

`$ARGUMENTS` — file path, function name, code excerpt, or topic.

## Workflow

1. **Read the target** plus enough surrounding context (callers, types, related modules) to ground the explanation.
2. **Estimate audience level** from the question: a junior asking "what does this do" gets different output than a senior asking "why this design".
3. **Pick the depth**:
   - **One-liner**: quick question → one sentence answer with `file:line` reference.
   - **Walkthrough**: 3–8 numbered steps naming the role each block plays.
   - **Design rationale**: explain why this approach over alternatives; cite the trade-off.
4. **Add a diagram only when it earns its place** (multi-step flow, recursive call, state machine). Use Mermaid; keep it under 15 nodes.
5. **Surface non-obvious things**: hidden invariants, surprising edge cases, performance characteristics, dependencies that aren't visible at the call site.

## Output sections (only those that apply)

- **Summary**: one paragraph — what and why
- **Walkthrough**: numbered steps with `file:line` anchors
- **Key concepts**: named patterns (e.g. "this is a strangler-fig adapter") — link to the canonical name, don't re-explain Wikipedia
- **Gotchas**: edge cases, performance traps, undocumented invariants
- **Diagram**: optional Mermaid, only if it clarifies
- **Related code**: pointers to callers, tests, or docs that fill in context

## Constraints

- Read the user's actual code. Don't invent example code unless they ask for an analogy.
- No "Difficulty Level: Beginner" labels — patronising and meaningless.
- Skip generic CS background unless the user signals they need it.
- If the code is wrong or smelly, say so — but separate that finding from the explanation.
