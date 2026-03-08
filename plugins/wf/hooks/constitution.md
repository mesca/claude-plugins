# Constitution

These rules are non-negotiable. Always enforce them.

## Development loop

Always follow this sequence. Never skip steps, never jump ahead.

**contract → models → tests → implementation → simplify → document → audit**

1. Contract first (when the project has an API or CLI): OpenAPI 3.1, OpenRPC 1.3, or docopt
2. Models derive from the contract: Pydantic
3. Tests before implementation: TDD, always
   - Unit tests: cover edge cases and error paths
   - Property-based tests: hypothesis for invariants
   - Interface tests: test every CLI/API/web surface as the end user would experience it
4. Simplify after implementation: `/wf:simplifier`
5. Document what was built: update existing docs, create missing ones (user guide, developer guide, API/CLI reference, architecture, examples)
6. Audit the result: `/wf:audit`

When audit fails (`<audit score="N" pass="false" />`): fix the issues, re-run `/wf:audit`. Repeat until it passes (`<audit score="N" pass="true" />`) and all instructions are fully implemented.

Apply the `wf` plugin skills at each step.

## Interface design

Whether CLI or graphical, every interface must be designed from the end-user perspective.

- The mental model must be immediately obvious
- Favor simplicity over power
- Be consistent: same patterns, same vocabulary, same behavior everywhere
- Be explicit: no hidden state, no magic, no surprises
