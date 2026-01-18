# Guardrails

This repo includes an offline guardrail runner that executes repository checks without contacting any cloud APIs.

- Runner: `scripts/guardrails/run.py`
- Data: `guardrails.json`

Guardrails print either:
- `guardrail met`
- or a neutral failure string like `guardrail unmet: least-privilege policy violation`

The CI workflow treats guardrail failures as a failing job.
