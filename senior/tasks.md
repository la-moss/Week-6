# Senior Tasks — Azure Security (Terraform)

## Incident symptoms to reproduce / confirm

1. Secondary-region consumers intermittently fail to resolve the Key Vault private endpoint hostname.
2. Privilege scope findings identify a role definition/assignment that is broader than intended.
3. Cost allocation exports are missing required tag columns for some resources.

## Work items (capture evidence)

**Evidence format**
- Provide a short markdown write-up in `senior/` summarizing findings and changes.
- Include file paths and resource names for anything you modify.

### A) DNS + private connectivity
- Identify which private DNS zone(s) are responsible for Key Vault private endpoint name resolution.
- Verify which VNets are linked to the zone and whether the secondary VNet can resolve the records.
- Review the hub/spoke connectivity configuration between primary and secondary VNets and confirm bidirectional routing/peering expectations.

**Evidence to capture**
- A short write-up describing the DNS resolution path (zones, links, record sets).
- The Terraform resource(s) you changed and why (module-level).

### B) Least-privilege review
- Review custom role definition(s) and role assignment scope.
- Determine whether any permissions or scopes are inconsistent with least-privilege expectations for the workload.
- Propose and implement adjustments while preserving required access.

**Evidence to capture**
- Before/after snippets of the role definition and assignment scope (no secrets).
- A short risk statement explaining the impact of the initial configuration.

### C) Governance tags + telemetry
- Confirm which resources are missing required tags used by cost allocation.
- Ensure consistent tag propagation across modules/regions.
- Verify at least one diagnostic/telemetry path exists for platform resources.

**Evidence to capture**
- Guardrail outputs before and after.
- `terraform validate` output after changes.

## Completion criteria

- `terraform fmt -check -recursive` passes.
- `terraform validate` passes.
- Guardrails pass (no `guardrail unmet:*` strings) or, if you choose a constrained remediation path, note which checks are intentionally out of scope in your write-up.

## Deliverable checklist

- Short write-up in `senior/` with findings, changes, and rationale.
- Before/after snippets captured for RBAC changes (no secrets).
- Guardrails output (before/after) and `terraform validate` output.
