# Azure Security Incident Lab (Terraform)

This repo is a hands-on incident-style lab focused on Azure security posture and governance using Terraform.

## Scenario

A rollout introduced a new Key Vault + Private Endpoint pattern for an internal platform. Shortly after:
- Access to secrets from workloads in the secondary region is unreliable.
- A security review flags privilege scope concerns in role definitions/assignments.
- Cost allocation reports are missing required tag dimensions for a subset of resources.

Your goal is to investigate and remediate while keeping the implementation production-grade and modular.

## How to run locally

### Prereqs
- Python 3.11+
- Terraform 1.6+

## Where to start

- Terraform root: `senior/terraform`
- Incident context: `tickets/INC-1047.md`
- Required artifacts: `senior/tasks.md`

### Setup
```bash
python3 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
```

### Terraform checks
```bash
terraform -chdir=senior/terraform init -backend=false
terraform -chdir=senior/terraform fmt -check -recursive
terraform -chdir=senior/terraform validate
```

### Guardrails (neutral checks)
Guardrails may fail until the incident is resolved. Expected failure strings include:
- `guardrail unmet: least-privilege policy violation`
- `guardrail unmet: required tags missing`
- `guardrail unmet: telemetry missing`

```bash
python3 scripts/guardrails/run.py --cloud azure --topic security --iac terraform --level senior --root senior/terraform --guardrails guardrails.json
```

## What to submit

See `senior/tasks.md` for artifacts and evidence to capture.

Follow on LinkedIn: https://www.linkedin.com/in/lam-ai
