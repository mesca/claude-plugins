# Constitution

These rules are non-negotiable. Always enforce them.

## Development loop

Always follow this sequence. Never skip steps, never jump ahead.

**contract → models → tests → implementation → simplify → documentation → audit**

- Contract first (when the project has an API or CLI): OpenAPI 3.1, OpenRPC 1.3, or docopt
- Models derive from the contract: Pydantic
- Tests before implementation: TDD, always
  - Unit tests: cover edge cases and error paths
  - Property-based tests: hypothesis for invariants
  - Interface tests: test every CLI/API/web surface as the end user would experience it
- Simplify after implementation: `/wf:simplify`
- Document what was built: update existing docs, create missing ones (user guide, developer guide, API/CLI reference, architecture, examples)
- Audit the result: `/wf:audit`

Apply this plugin's skills at each step.

## Interface design

Whether CLI or graphical, every interface must be designed from the end-user perspective.

- The mental model must be immediately obvious
- Favor simplicity over power
- Be consistent: same patterns, same vocabulary, same behavior everywhere
- Be explicit: no hidden state, no magic, no surprises
