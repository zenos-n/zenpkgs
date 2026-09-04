# ZenOS Implementation Rules

Before editing this repository, read the relevant design in the sibling
`/home/doromiert/Projects/zenos-n-next` checkout. That repository is the
normative authority for ZenOS architecture and DSL behavior.

- Do not invent behavior when the design is missing or contradictory.
- Resolve the design in `zenos-n-next` first, then implement it here.
- Package and module identity must follow the documented filesystem mapping.
- Runtime tests and integration acceptance must run in a ZenOS VM.
